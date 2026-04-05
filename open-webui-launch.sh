#!/bin/zsh

set -euo pipefail

LOG_DIR="${HOME}/Library/Logs/OpenWebUILauncher"
APP_DIR="${HOME}/Library/Application Support/OpenWebUILauncher"
mkdir -p "${LOG_DIR}"
mkdir -p "${APP_DIR}/data"

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"
export DATA_DIR="${APP_DIR}/data"

OPEN_WEBUI_BIN="/opt/homebrew/bin/open-webui"

if [[ ! -x "${OPEN_WEBUI_BIN}" ]] && ! command -v open-webui >/dev/null 2>&1; then
  echo "$(date '+%Y-%m-%d %H:%M:%S') open-webui not found in PATH" >> "${LOG_DIR}/launcher-error.log"
  exit 127
fi

if [[ ! -x "${OPEN_WEBUI_BIN}" ]]; then
  OPEN_WEBUI_BIN="$(command -v open-webui)"
fi

exec "${OPEN_WEBUI_BIN}" serve --host 127.0.0.1 --port 8080 >> "${LOG_DIR}/open-webui.stdout.log" 2>> "${LOG_DIR}/open-webui.stderr.log"
