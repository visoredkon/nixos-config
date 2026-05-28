#!/usr/bin/env bash

set -euo pipefail

readonly ACCESS_POINT_IF="ap0"
readonly CHANNELS=(1 6 11)
readonly WIFI_IF="wlan0"

readonly FIREWALL_AP_INPUT_CHAIN="auto-ap-input-fw"
readonly FIREWALL_AP_INPUT_JUMP_COMMENT="auto-ap-jump-input"
readonly FIREWALL_FORWARD_CHAIN="auto-ap-forward-fw"
readonly FIREWALL_FORWARD_JUMP_COMMENT="auto-ap-jump-forward"

readonly SCAN_MAX_ATTEMPTS=3
readonly SCAN_RETRY_DELAY_SECONDS=2
readonly STATE_DIR="/tmp/auto-ap"
readonly CREDENTIAL_PASSPHRASE_FILE="$STATE_DIR/passphrase"
readonly CREDENTIAL_SSID_FILE="$STATE_DIR/ssid"
readonly RUNNER_LOG_FILE="$STATE_DIR/${WIFI_IF}.log"
readonly RUNNER_PID_FILE="$STATE_DIR/${WIFI_IF}.pid"

ACTION="help"
FORCE_CREDENTIAL_PROMPT=0

CLEANUP_DONE=0
INITIAL_WIFI_STATE=""
SUDO_KEEPALIVE_PID=""

RUNNER_PID=""
SSID=""
PASSPHRASE=""

die() {
  echo "Error: $*" >&2
  exit 1
}

info() {
  printf '==> %s\n' "$*" >&2
}

usage() {
  local script_name
  script_name="${0##*/}"

  cat <<EOF
Usage: $script_name

Automatically selects the least-interfered 2.4GHz Wi-Fi channel (1/6/11) and runs create_ap.

Commands:
  start    Start AP in background
  stop     Stop AP
  restart  Restart AP
  status   Stream realtime AP log

Flags:
  --refresh-credentials   Prompt SSID/passphrase again and override cache (start/restart only)
EOF
}

parse_args() {
  while (($# > 0)); do
    case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    restart | run | start | status | stop)
      ACTION="$1"
      ;;
    --refresh-credentials)
      FORCE_CREDENTIAL_PROMPT=1
      ;;
    *)
      die "Unknown option: $1"
      ;;
    esac
    shift
  done
}

validate_args() {
  if ((FORCE_CREDENTIAL_PROMPT == 1)) && [[ $ACTION != "start" && $ACTION != "restart" ]]; then
    die "--refresh-credentials can only be used with start or restart"
  fi
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing dependency: $1"
}

require_deps() {
  local cmd
  local deps=(awk create_ap ip iw nmcli sudo)

  for cmd in "${deps[@]}"; do
    require_cmd "$cmd"
  done
}

require_sudo() {
  local mode="${1:-interactive}"

  info "Requesting sudo access..."

  case "$mode" in
  interactive)
    sudo -v || die "Failed to acquire sudo privileges"
    ;;
  noninteractive)
    run_sudo true || die "Sudo session is not active. Run '$0 start' again."
    ;;
  *)
    die "Invalid sudo mode: $mode"
    ;;
  esac
}

run_sudo() {
  sudo -n "$@"
}

start_sudo_keepalive() {
  local owner_pid="$BASHPID"

  if [[ -n $SUDO_KEEPALIVE_PID ]] && kill -0 "$SUDO_KEEPALIVE_PID" >/dev/null 2>&1; then
    return
  fi

  (
    while true; do
      sleep 30
      kill -0 "$owner_pid" >/dev/null 2>&1 || exit 0
      run_sudo true || exit 0
    done
  ) >/dev/null 2>&1 &

  SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
  if [[ -z $SUDO_KEEPALIVE_PID ]]; then
    return
  fi

  if kill -0 "$SUDO_KEEPALIVE_PID" >/dev/null 2>&1; then
    kill "$SUDO_KEEPALIVE_PID" >/dev/null 2>&1 || true
    wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
  fi

  SUDO_KEEPALIVE_PID=""
}

ensure_state_dir() {
  mkdir -p "$STATE_DIR"
  chmod 700 "$STATE_DIR"
}

cache_credentials() {
  ensure_state_dir

  (
    umask 077
    printf '%s\n' "$SSID" >"$CREDENTIAL_SSID_FILE"
    printf '%s\n' "$PASSPHRASE" >"$CREDENTIAL_PASSPHRASE_FILE"
  )

  chmod 600 "$CREDENTIAL_SSID_FILE" "$CREDENTIAL_PASSPHRASE_FILE"
}

credentials_cache_exists() {
  [[ -s $CREDENTIAL_SSID_FILE && -s $CREDENTIAL_PASSPHRASE_FILE ]]
}

load_cached_credentials() {
  local cached_passphrase
  local cached_ssid

  credentials_cache_exists || return 1

  cached_ssid=$(<"$CREDENTIAL_SSID_FILE")
  cached_passphrase=$(<"$CREDENTIAL_PASSPHRASE_FILE")

  ssid_is_valid "$cached_ssid" || return 1
  passphrase_is_valid "$cached_passphrase" || return 1

  SSID="$cached_ssid"
  PASSPHRASE="$cached_passphrase"
}

passphrase_is_valid() {
  local passphrase="$1"
  ((${#passphrase} >= 8 && ${#passphrase} <= 63))
}

ssid_is_valid() {
  local ssid="$1"
  ((${#ssid} >= 1 && ${#ssid} <= 32))
}

prompt_credentials() {
  local passphrase
  local passphrase_confirm
  local ssid

  [[ -r /dev/tty && -w /dev/tty ]] || die "Interactive credential prompt requires a TTY"

  while true; do
    printf 'SSID: ' >/dev/tty
    IFS= read -r ssid </dev/tty || die "Failed to read SSID"
    if ssid_is_valid "$ssid"; then
      break
    fi
    info "SSID must be 1-32 characters"
  done

  while true; do
    printf 'Passphrase: ' >/dev/tty
    IFS= read -r -s passphrase </dev/tty || die "Failed to read passphrase"
    printf '\n' >/dev/tty

    printf 'Confirm passphrase: ' >/dev/tty
    IFS= read -r -s passphrase_confirm </dev/tty || die "Failed to confirm passphrase"
    printf '\n' >/dev/tty

    if [[ $passphrase != "$passphrase_confirm" ]]; then
      info "Passphrase confirmation does not match"
      continue
    fi

    if passphrase_is_valid "$passphrase"; then
      break
    fi

    info "Passphrase must be 8-63 characters"
  done

  SSID="$ssid"
  PASSPHRASE="$passphrase"
}

read_runner_pid() {
  if [[ ! -f $RUNNER_PID_FILE ]]; then
    return 1
  fi

  tr -d '[:space:]' <"$RUNNER_PID_FILE"
}

write_runner_pid() {
  local pid="$1"
  ensure_state_dir
  printf '%s\n' "$pid" >"$RUNNER_PID_FILE"
}

remove_runner_pid() {
  rm -f "$RUNNER_PID_FILE"
}

pid_is_running() {
  local pid="$1"
  [[ $pid =~ ^[0-9]+$ ]] && kill -0 "$pid" >/dev/null 2>&1
}

is_runner_running() {
  local pid

  pid=$(read_runner_pid || true)
  if [[ -z $pid ]]; then
    return 1
  fi

  if ! pid_is_running "$pid"; then
    remove_runner_pid
    return 1
  fi

  RUNNER_PID="$pid"
  return 0
}

require_cached_credentials() {
  load_cached_credentials || die "Credential cache missing or invalid. Run '$0 start --refresh-credentials'."
}

resolve_start_credentials() {
  if ((FORCE_CREDENTIAL_PROMPT == 1)); then
    info "Refreshing SSID and passphrase from interactive prompt..."
    prompt_credentials
    cache_credentials
    return
  fi

  if load_cached_credentials; then
    info "Using cached SSID and passphrase"
    return
  fi

  info "Credential cache missing or invalid, prompting for SSID and passphrase..."
  prompt_credentials
  cache_credentials
}

firewall_chain_exists() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"
  run_sudo nft list chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1
}

firewall_delete_chain() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"

  if ! firewall_chain_exists "$family" "$table_name" "$chain_name"; then
    return
  fi

  run_sudo nft flush chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1 || true
  run_sudo nft delete chain "$family" "$table_name" "$chain_name" >/dev/null 2>&1 || true
}

firewall_delete_rule_by_comment() {
  local chain_name="$1"
  local comment="$2"
  local handle

  while true; do
    handle=$(firewall_find_rule_handle_by_comment "$chain_name" "$comment")
    [[ -n $handle ]] || break
    run_sudo nft delete rule inet nixos-fw "$chain_name" handle "$handle" >/dev/null 2>&1 || break
  done
}

firewall_find_rule_handle_by_comment() {
  local chain_name="$1"
  local comment="$2"

  run_sudo nft -a list chain inet nixos-fw "$chain_name" 2>/dev/null | awk -v comment="$comment" '
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

firewall_recreate_chain() {
  local family="$1"
  local table_name="$2"
  local chain_name="$3"

  firewall_delete_chain "$family" "$table_name" "$chain_name"
  run_sudo nft add chain "$family" "$table_name" "$chain_name"
}

firewall_tool_available() {
  command -v nft >/dev/null 2>&1
}

interface_exists() {
  local ifname="$1"
  [[ -n $ifname && -d "/sys/class/net/$ifname" ]]
}

interface_has_global_ipv4() {
  local ifname="$1"
  ip -o -4 addr show dev "$ifname" scope global 2>/dev/null | grep -q .
}

interface_is_up() {
  local ifname="$1"
  ip -o link show dev "$ifname" 2>/dev/null | grep -Eq '<[^>]*UP[^>]*>'
}

interface_is_valid_inet_candidate() {
  local ifname="$1"

  [[ $ifname != "$WIFI_IF" ]] || return 1
  [[ $ifname != "lo" ]] || return 1
  interface_exists "$ifname" || return 1
  interface_has_global_ipv4 "$ifname" || return 1
  interface_is_up "$ifname" || return 1
}

interface_is_wireless() {
  local ifname="$1"
  iw dev "$ifname" info >/dev/null 2>&1
}

assert_wifi_interface_ready() {
  interface_exists "$WIFI_IF" || die "Wi-Fi interface not found: $WIFI_IF"
  interface_is_wireless "$WIFI_IF" || die "Interface is not wireless: $WIFI_IF"
}

list_default_route_interfaces() {
  ip -o -4 route show default 2>/dev/null |
    awk '
      {
        for (i = 1; i <= NF; i++) {
          if ($i == "dev") {
            print $(i + 1)
            break
          }
        }
      }
    ' |
    awk '!seen[$0]++'
}

list_global_ipv4_interfaces() {
  ip -o -4 addr show up scope global 2>/dev/null |
    awk '{print $2}' |
    awk '!seen[$0]++'
}

detect_inet_if() {
  local candidate

  while IFS= read -r candidate; do
    [[ -n $candidate ]] || continue
    if interface_is_valid_inet_candidate "$candidate"; then
      printf '%s\n' "$candidate"
      return
    fi
  done < <(list_default_route_interfaces)

  while IFS= read -r candidate; do
    [[ -n $candidate ]] || continue
    if interface_is_valid_inet_candidate "$candidate"; then
      printf '%s\n' "$candidate"
      return
    fi
  done < <(list_global_ipv4_interfaces)

  die "Unable to detect a valid internet interface"
}

get_wifi_radio_state() {
  local state

  state=$(nmcli -t -f WIFI radio 2>/dev/null) || die "Unable to read Wi-Fi radio state"

  if [[ $state != "enabled" && $state != "disabled" ]]; then
    die "Unexpected Wi-Fi radio state: $state"
  fi

  printf '%s\n' "$state"
}

set_wifi_radio_state() {
  local state="$1"

  case "$state" in
  enabled)
    nmcli radio wifi on >/dev/null
    ;;
  disabled)
    nmcli radio wifi off >/dev/null
    ;;
  *)
    die "Invalid Wi-Fi state: $state"
    ;;
  esac
}

enable_wifi_if_needed() {
  if [[ $INITIAL_WIFI_STATE == "disabled" ]]; then
    info "Enabling Wi-Fi..."
    set_wifi_radio_state enabled
    sleep 2
  fi
}

restore_wifi_state() {
  if [[ -z $INITIAL_WIFI_STATE ]]; then
    return
  fi

  info "Restoring Wi-Fi state: $INITIAL_WIFI_STATE"
  set_wifi_radio_state "$INITIAL_WIFI_STATE"
}

disconnect_wifi_if() {
  info "Disconnecting $WIFI_IF from active networks..."

  if ! run_sudo nmcli device disconnect "$WIFI_IF" >/dev/null 2>&1; then
    info "$WIFI_IF was already disconnected or unmanaged"
  fi
}

setup_runtime_ap_firewall_rules() {
  local inet_if="$1"
  local has_forward_chain=0

  if ! firewall_tool_available; then
    return
  fi

  if ! firewall_chain_exists inet nixos-fw input; then
    return
  fi

  if firewall_chain_exists inet nixos-fw forward; then
    has_forward_chain=1
  fi

  info "Applying temporary access-point firewall rules..."

  firewall_delete_rule_by_comment input "$FIREWALL_AP_INPUT_JUMP_COMMENT"
  firewall_recreate_chain inet nixos-fw "$FIREWALL_AP_INPUT_CHAIN"
  run_sudo nft insert rule inet nixos-fw input jump "$FIREWALL_AP_INPUT_CHAIN" comment "$FIREWALL_AP_INPUT_JUMP_COMMENT"
  run_sudo nft add rule inet nixos-fw "$FIREWALL_AP_INPUT_CHAIN" iifname "$ACCESS_POINT_IF" tcp dport '{ 53, 5353 }' accept
  run_sudo nft add rule inet nixos-fw "$FIREWALL_AP_INPUT_CHAIN" iifname "$ACCESS_POINT_IF" udp dport '{ 53, 5353, 67, 5520 }' accept

  if ((has_forward_chain == 1)); then
    firewall_delete_rule_by_comment forward "$FIREWALL_FORWARD_JUMP_COMMENT"
    firewall_recreate_chain inet nixos-fw "$FIREWALL_FORWARD_CHAIN"
    run_sudo nft insert rule inet nixos-fw forward jump "$FIREWALL_FORWARD_CHAIN" comment "$FIREWALL_FORWARD_JUMP_COMMENT"
    run_sudo nft add rule inet nixos-fw "$FIREWALL_FORWARD_CHAIN" iifname "$ACCESS_POINT_IF" oifname "$inet_if" accept
    run_sudo nft add rule inet nixos-fw "$FIREWALL_FORWARD_CHAIN" iifname "$inet_if" oifname "$ACCESS_POINT_IF" ct state related,established accept
  fi
}

remove_runtime_ap_firewall_rules() {
  if ! firewall_tool_available; then
    return
  fi

  firewall_delete_rule_by_comment input "$FIREWALL_AP_INPUT_JUMP_COMMENT"
  firewall_delete_rule_by_comment forward "$FIREWALL_FORWARD_JUMP_COMMENT"
  firewall_delete_chain inet nixos-fw "$FIREWALL_FORWARD_CHAIN"
  firewall_delete_chain inet nixos-fw "$FIREWALL_AP_INPUT_CHAIN"
}

scan_wifi() {
  run_sudo iw dev "$WIFI_IF" scan 2>/dev/null
}

scan_wifi_with_retry() {
  local attempt
  local scan
  local delay=$SCAN_RETRY_DELAY_SECONDS

  for ((attempt = 1; attempt <= SCAN_MAX_ATTEMPTS; attempt++)); do
    scan=$(scan_wifi || true)

    if [[ -n $scan ]]; then
      printf '%s\n' "$scan"
      return
    fi

    if ((attempt < SCAN_MAX_ATTEMPTS)); then
      info "Scan attempt $attempt/$SCAN_MAX_ATTEMPTS returned no data; retrying in ${delay}s..."
      sleep "$delay"
      delay=$((delay * 2))
    fi
  done

  die "Unable to collect Wi-Fi scan data"
}

is_float_less() {
  local left="$1"
  local right="$2"
  awk -v left="$left" -v right="$right" 'BEGIN {exit !(left < right)}'
}

score_channel() {
  local channel="$1"
  local scan="$2"

  awk -v ch="$channel" '
  function abs(x) { return x < 0 ? -x : x }
  function flush() {
    if (sig == "" || chan == "")
      return

    delta = abs(chan - ch)

    if (delta == 0)
      score += pow10(sig)
    else if (delta == 1)
      score += 0.5 * pow10(sig)
    else if (delta == 2)
      score += 0.25 * pow10(sig)

    sig = ""
    chan = ""
  }
  function pow10(x) { return 10^(x/10) }

  /^BSS / { flush() }
  /signal:/ { sig = $2 + 0 }
  /DS Parameter set:/ { chan = $5 + 0; flush() }
  /primary channel:/ {
    if (chan == "")
      chan = $3 + 0
    flush()
  }

  END {
    flush()
    print score + 0
  }
  ' <<<"$scan"
}

select_best_channel() {
  local scan="$1"

  local best_channel=""
  local best_score=""
  local ch
  local score

  for ch in "${CHANNELS[@]}"; do
    score=$(score_channel "$ch" "$scan")

    info "channel $ch score: $score"

    if [[ -z $best_channel ]] || is_float_less "$score" "$best_score"; then
      best_channel="$ch"
      best_score="$score"
    fi
  done

  printf '%s\n' "$best_channel"
}

start_ap() {
  local channel="$1"
  local inet_if="$2"

  info "Starting AP on channel $channel using $inet_if"

  run_sudo create_ap \
    --freq-band 2.4 \
    --ieee80211n \
    --ht_capab '[HT20]' \
    -c "$channel" \
    "$WIFI_IF" \
    "$inet_if" \
    "$SSID" \
    "$PASSPHRASE"
}

cleanup() {
  local exit_code=$?
  trap - EXIT

  if ((CLEANUP_DONE == 1)); then
    exit "$exit_code"
  fi

  CLEANUP_DONE=1
  set +e

  remove_runtime_ap_firewall_rules
  remove_runner_pid
  stop_sudo_keepalive
  restore_wifi_state

  exit "$exit_code"
}

run_action() {
  trap cleanup EXIT

  require_deps
  require_cached_credentials
  require_sudo noninteractive
  start_sudo_keepalive
  assert_wifi_interface_ready

  write_runner_pid "$BASHPID"

  INITIAL_WIFI_STATE=$(get_wifi_radio_state)
  info "Initial Wi-Fi state: $INITIAL_WIFI_STATE"

  enable_wifi_if_needed

  local inet_if
  inet_if=$(detect_inet_if)
  info "Detected internet interface: $inet_if"

  setup_runtime_ap_firewall_rules "$inet_if"

  disconnect_wifi_if

  info "Scanning Wi-Fi environment..."

  local scan
  scan=$(scan_wifi_with_retry)

  local best_channel
  best_channel=$(select_best_channel "$scan")

  info "Selected channel: $best_channel"

  start_ap "$best_channel" "$inet_if"
}

start_action() {
  local runner_pid

  require_cmd nohup
  require_deps

  if is_runner_running; then
    info "AP is already running (PID: $RUNNER_PID)"
    return
  fi

  resolve_start_credentials
  require_sudo interactive

  ensure_state_dir

  nohup "$0" run >"$RUNNER_LOG_FILE" 2>&1 &
  runner_pid=$!
  write_runner_pid "$runner_pid"

  sleep 1
  if ! pid_is_running "$runner_pid"; then
    remove_runner_pid
    die "Failed to start AP. Check log: $RUNNER_LOG_FILE"
  fi

  info "AP started in background (PID: $runner_pid)"
  info "Log file: $RUNNER_LOG_FILE"
}

stop_action() {
  local _

  if ! is_runner_running; then
    info "AP is not running"
    return
  fi

  require_cmd create_ap
  require_sudo interactive

  info "Stopping AP (PID: $RUNNER_PID)..."
  run_sudo create_ap --stop "$WIFI_IF" >/dev/null 2>&1 || true

  for ((_ = 1; _ <= 15; _++)); do
    if ! pid_is_running "$RUNNER_PID"; then
      break
    fi
    sleep 1
  done

  if pid_is_running "$RUNNER_PID"; then
    kill "$RUNNER_PID" >/dev/null 2>&1 || true
  fi

  remove_runner_pid
  remove_runtime_ap_firewall_rules
  info "AP stopped"
}

status_action() {
  if is_runner_running; then
    info "AP is running (PID: $RUNNER_PID)"
    require_cmd tail
    exec tail -n 40 -f "$RUNNER_LOG_FILE"
    return
  fi

  info "AP is not running"
}

restart_action() {
  stop_action
  start_action
}

main() {
  parse_args "$@"
  validate_args

  case "$ACTION" in
  help)
    usage
    ;;
  run)
    run_action
    ;;
  start)
    start_action
    ;;
  restart)
    restart_action
    ;;
  status)
    status_action
    ;;
  stop)
    stop_action
    ;;
  *)
    die "Unsupported action: $ACTION"
    ;;
  esac
}

main "$@"
