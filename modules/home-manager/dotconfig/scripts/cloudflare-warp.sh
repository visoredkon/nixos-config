#!/usr/bin/env bash

set -euo pipefail

readonly MAX_RETRIES=5
readonly INITIAL_RETRY_INTERVAL=5
readonly CONNECTIVITY_TARGETS=(1.1.1.1 8.8.8.8 cloudflare-dns.com google.com)

readonly FIREWALL_WARP_INPUT_CHAIN="auto-warp-input-fw"
readonly FIREWALL_WARP_INPUT_JUMP_COMMENT="auto-warp-jump-input"
readonly FIREWALL_WARP_RPFILTER_CHAIN="auto-warp-rpfilter-fw"
readonly FIREWALL_WARP_RPFILTER_JUMP_COMMENT="auto-warp-jump-rpfilter"

CLEANUP_DONE=0

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

firewall_chain_exists() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"
  sudo nft list chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1
}

firewall_delete_chain() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"

  if ! firewall_chain_exists "$family" "$table_name" "$chain_name"; then
    return
  fi

  sudo nft flush chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1 || true
  sudo nft delete chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1 || true
}

firewall_find_rule_handle_by_comment() {
  local chain_name="$1"
  local comment="$2"

  sudo nft -a list chain inet nixos-fw "$chain_name" 2>/dev/null | awk -v comment="$comment" '
    index($0, "comment \"" comment "\"") {
      for (i = 1; i <= NF; i++) {
        if ($i == "handle") {
          print $(i + 1)
          exit
        }
      }
    }
  '
}

firewall_delete_rule_by_comment() {
  local chain_name="$1"
  local comment="$2"
  local handle

  while true; do
    handle=$(firewall_find_rule_handle_by_comment "$chain_name" "$comment")
    [[ -n $handle ]] || break
    sudo nft delete rule inet nixos-fw "$chain_name" handle "$handle" >/dev/null 2>&1 || break
  done
}

firewall_recreate_chain() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"

  firewall_delete_chain "$family" "$table_name" "$chain_name"
  sudo nft add chain "$family" "$table_name" "$chain_name"
}

firewall_tool_available() {
  command -v nft >/dev/null 2>&1
}

setup_warp_firewall() {
  local has_rpfilter=0

  if ! firewall_chain_exists inet nixos-fw input; then
    return
  fi

  if firewall_chain_exists inet nixos-fw rpfilter; then
    has_rpfilter=1
  fi

  info "Setting up WARP firewall rules..."

  firewall_delete_rule_by_comment input "$FIREWALL_WARP_INPUT_JUMP_COMMENT"
  firewall_recreate_chain inet nixos-fw "$FIREWALL_WARP_INPUT_CHAIN"
  sudo nft insert rule inet nixos-fw input jump "$FIREWALL_WARP_INPUT_CHAIN" comment "$FIREWALL_WARP_INPUT_JUMP_COMMENT"
  sudo nft add rule inet nixos-fw "$FIREWALL_WARP_INPUT_CHAIN" iifname "CloudflareWARP" accept

  if ((has_rpfilter == 1)); then
    firewall_delete_rule_by_comment rpfilter "$FIREWALL_WARP_RPFILTER_JUMP_COMMENT"
    firewall_recreate_chain inet nixos-fw "$FIREWALL_WARP_RPFILTER_CHAIN"
    sudo nft insert rule inet nixos-fw rpfilter jump "$FIREWALL_WARP_RPFILTER_CHAIN" comment "$FIREWALL_WARP_RPFILTER_JUMP_COMMENT"
    sudo nft add rule inet nixos-fw "$FIREWALL_WARP_RPFILTER_CHAIN" "ip6 saddr { $CF_IPV6 } accept"
    sudo nft add rule inet nixos-fw "$FIREWALL_WARP_RPFILTER_CHAIN" "ip saddr { $CF_IPV4 } accept"
    sudo nft add rule inet nixos-fw "$FIREWALL_WARP_RPFILTER_CHAIN" 'iifname "CloudflareWARP" accept'
  fi
}

remove_warp_firewall() {
  if ! firewall_tool_available; then
    return
  fi

  firewall_delete_rule_by_comment input "$FIREWALL_WARP_INPUT_JUMP_COMMENT"
  firewall_delete_chain inet nixos-fw "$FIREWALL_WARP_INPUT_CHAIN"

  if firewall_chain_exists inet nixos-fw rpfilter; then
    firewall_delete_rule_by_comment rpfilter "$FIREWALL_WARP_RPFILTER_JUMP_COMMENT"
    firewall_delete_chain inet nixos-fw "$FIREWALL_WARP_RPFILTER_CHAIN"
  fi
}

is_connected() {
  warp-cli status 2>/dev/null | grep -q "Status update: Connected$"
}

is_disconnected() {
  warp-cli status 2>/dev/null | grep -q "Status update: Disconnected"
}

cleanup() {
  local exit_code=$?
  trap - INT TERM

  if ((CLEANUP_DONE == 1)); then
    exit "$exit_code"
  fi

  CLEANUP_DONE=1
  set +e

  info "Interrupted, rolling back..."
  is_disconnected || warp-cli disconnect 2>/dev/null || true
  remove_warp_firewall

  exit "$exit_code"
}

fetch_cloudflare_ips() {
  info "Fetching Cloudflare IP ranges..."
  local response
  response=$(curl -sf https://api.cloudflare.com/client/v4/ips) ||
    die "Failed to fetch Cloudflare IP ranges"
  CF_IPV4=$(echo "$response" | jq -r '.result.ipv4_cidrs[]' | paste -sd ',')
  CF_IPV6=$(echo "$response" | jq -r '.result.ipv6_cidrs[]' | paste -sd ',')
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

  trap cleanup INT TERM

  fetch_cloudflare_ips
  setup_warp_firewall

  info "Connecting WARP..."
  if ! warp-cli connect; then
    remove_warp_firewall
    die "Failed to initiate WARP connection"
  fi
  sleep 2
  info "Waiting for WARP to connect..."
  if ! wait_for_connected; then
    info "WARP failed to connect, disconnecting..."
    warp-cli disconnect 2>/dev/null || true
    remove_warp_firewall
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

  trap cleanup INT TERM

  info "Disconnecting WARP..."
  warp-cli disconnect || die "Failed to disconnect WARP"
  remove_warp_firewall
  trap - INT TERM
  info "WARP disconnected successfully."
}

cmd_restart() {
  cmd_down
  cmd_up
}

usage() {
  cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  up        Connect WARP
  down      Disconnect WARP
  restart   Restart WARP
EOF
}

parse_args() {
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
  require_cmd curl
  require_cmd jq

  if [[ $# -eq 0 || $1 == -h || $1 == --help ]]; then
    usage
    exit 0
  fi

  require_sudo
  parse_args "$@"
}

main "$@"
