#!/usr/bin/env bash

set -euo pipefail

readonly MAX_RETRIES=5
readonly INITIAL_RETRY_INTERVAL=5
readonly CONNECTIVITY_TARGETS=(1.1.1.1 8.8.8.8 cloudflare-dns.com google.com)

die() {
  echo "Error: $*" >&2
  exit 1
}
info() { printf '==> %s\n' "$*" >&2; }
warn() { printf '==> Warning: %s\n' "$*" >&2; }
require_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"; }

require_sudo() {
  info "Requesting sudo access..."
  sudo -v || die "Failed to acquire sudo privileges"
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &
}

is_connected() {
  warp-cli status 2>/dev/null | grep -q "Status update: Connected$"
}

is_disconnected() {
  warp-cli status 2>/dev/null | grep -q "Status update: Disconnected"
}

restore_firewall() {
  info "Restoring nixos firewall..."
  sudo systemctl restart nftables.service || true
}

cleanup() {
  info "Interrupted, rolling back..."
  is_disconnected || warp-cli disconnect 2>/dev/null || true
  restore_firewall
  exit 1
}

fetch_cloudflare_ips() {
  info "Fetching Cloudflare IP ranges..."
  local response
  response=$(curl -sf https://api.cloudflare.com/client/v4/ips) ||
    die "Failed to fetch Cloudflare IP ranges"
  CF_IPV4=$(echo "$response" | jq -r '.result.ipv4_cidrs[]' | paste -sd ',')
  CF_IPV6=$(echo "$response" | jq -r '.result.ipv6_cidrs[]' | paste -sd ',')
}

patch_nixos_fw() {
  info "Patching nixos-fw for WARP compatibility..."
  sudo nft insert rule inet nixos-fw rpfilter "ip6 saddr { $CF_IPV6 } accept"
  sudo nft insert rule inet nixos-fw rpfilter "ip saddr { $CF_IPV4 } accept"
  sudo nft insert rule inet nixos-fw rpfilter 'iifname "CloudflareWARP" accept'
  sudo nft insert rule inet nixos-fw input 'iifname "CloudflareWARP" accept'
}

check_connectivity() {
  info "Checking connectivity..."
  local failed=0
  for target in "${CONNECTIVITY_TARGETS[@]}"; do
    if ping -c 2 -W 3 "$target" &>/dev/null; then
      info "OK: $target"
    else
      warn "Unreachable: $target"
      ((failed++)) || true
    fi
  done
  [[ $failed -gt 0 ]] && warn "$failed/${#CONNECTIVITY_TARGETS[@]} targets unreachable"
  return 0
}

wait_for_connected() {
  local attempt=1
  local delay=$INITIAL_RETRY_INTERVAL
  while [[ $attempt -le $MAX_RETRIES ]]; do
    if is_connected; then
      sleep 3
      return 0
    fi
    info "Attempt $attempt/$MAX_RETRIES failed, retrying in ${delay}s..."
    sleep "$delay"
    delay=$((delay * 2))
    ((attempt++))
  done
  return 1
}

cmd_up() {
  if is_connected; then
    info "WARP is already connected."
    exit 0
  fi
  fetch_cloudflare_ips
  patch_nixos_fw
  trap cleanup INT TERM
  info "Connecting WARP..."
  if ! warp-cli connect; then
    restore_firewall
    die "Failed to initiate WARP connection"
  fi
  sleep 2
  info "Waiting for WARP to connect..."
  if ! wait_for_connected; then
    info "WARP failed to connect, disconnecting..."
    warp-cli disconnect 2>/dev/null || true
    restore_firewall
    die "WARP failed to establish connection"
  fi
  trap - INT TERM
  check_connectivity
  info "WARP connected successfully."
}

cmd_down() {
  if is_disconnected; then
    info "WARP is already disconnected."
    exit 0
  fi
  info "Disconnecting WARP..."
  warp-cli disconnect || die "Failed to disconnect WARP"
  restore_firewall
  info "WARP disconnected successfully."
}

cmd_restart() {
  cmd_down
  cmd_up
}

parse_args() {
  [[ $# -eq 0 ]] && die "No command provided. Use: up, down, restart"
  case "$1" in
  up) cmd_up ;;
  down) cmd_down ;;
  restart) cmd_restart ;;
  *) die "Unknown command: $1. Use: up, down, restart" ;;
  esac
}

main() {
  require_cmd warp-cli
  require_cmd nft
  require_cmd systemctl
  require_cmd curl
  require_cmd jq
  require_sudo
  parse_args "$@"
}

main "$@"
