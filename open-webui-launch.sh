#!/bin/zsh

set -euo pipefail

LOG_DIR="${HOME}/Library/Logs/OpenWebUILauncher"
mkdir -p "${LOG_DIR}"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

if ! command -v open-webui >/dev/null 2>&1; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') open-webui not found in PATH" >> "${LOG_DIR}/launcher-error.log"
  exit 127
fi

exec open-webui serve >> "${LOG_DIR}/open-webui.stdout.log" 2>> "${LOG_DIR}/open-webui.stderr.log"
