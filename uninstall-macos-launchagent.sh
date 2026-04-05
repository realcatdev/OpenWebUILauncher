#!/bin/zsh

set -euo pipefail

AGENT_ID="local.openwebui.launcher"
PLIST_PATH="${HOME}/Library/LaunchAgents/${AGENT_ID}.plist"
APP_SUPPORT_DIR="${HOME}/Library/Application Support/OpenWebUILauncher"

launchctl bootout "gui/$(id -u)/${AGENT_ID}" >/dev/null 2>&1 || true
rm -f "${PLIST_PATH}"

echo "removed ${AGENT_ID}"
