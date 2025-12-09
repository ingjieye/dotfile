#!/bin/zsh
exit 0

# This script:
# 1. automatically executed by ~/Library/LaunchAgents/com.user.wifimonitor.plist
# 2. runs scripts in ~/.config/network/wifi-change.d/ when a Wi-Fi network change is detected.
# 3. passes the SSID and MAC address of the current network as arguments to the scripts it executes.

# Log configuration
readonly LOG_DIR="$HOME/.local/log"
readonly LOG_FILE="$LOG_DIR/wifi-change-dispatcher.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

# Logging function
log_message() {
  local message="$1"
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] $message" | tee -a "$LOG_FILE"
}

run_scripts() {
  readonly SCRIPT_DIR="$HOME/.config/network/wifi-change.d"

  log_message "Wi-Fi change dispatcher started"

  if [[ ! -d "$SCRIPT_DIR" ]]; then
    log_message "ERROR: Script directory '$SCRIPT_DIR' not found."
    return
  fi

  SSID=$(shortcuts run WRITE_SSID_TO_FILE)
  
  # If SSID is empty, it means not connected to any Wi-Fi, so just return
  if [[ -z "$SSID" ]]; then
    log_message "Network change detected, but not connected to a Wi-Fi network. Skipping."
    return
  fi

  log_message "Wi-Fi is connected to '$SSID'. Executing scripts from: $SCRIPT_DIR"
  
  for script in "$SCRIPT_DIR"/*; do
    if [[ -f "$script" && -x "$script" ]]; then
      log_message "-> Running: $(basename "$script")"
      # Use a pipe to read the script's output line by line and log it
      "$script" "$SSID" 2>&1 | while IFS= read -r line; do
        log_message "  [$(basename "$script")] $line"
      done
      local exit_code=${pipestatus[1]}
      log_message "-> Finished: $(basename "$script") with exit code $exit_code"
    else
      log_message "-> Skipping (not a regular executable file): $(basename "$script")"
    fi
  done
  
  log_message "All scripts dispatched"
}

run_scripts

log_message "Wi-Fi change dispatcher finished"

exit 0
