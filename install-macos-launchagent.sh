#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_ID="local.openwebui.launcher"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/${AGENT_ID}.plist"
LOG_DIR="${HOME}/Library/Logs/OpenWebUILauncher"
WRAPPER_PATH="${SCRIPT_DIR}/open-webui-launch.sh"

mkdir -p "${LAUNCH_AGENTS_DIR}" "${LOG_DIR}"

cat > "${PLIST_PATH}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${AGENT_ID}</string>

  <key>ProgramArguments</key>
  <array>
    <string>${WRAPPER_PATH}</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <true/>

  <key>WorkingDirectory</key>
  <string>${SCRIPT_DIR}</string>

  <key>StandardOutPath</key>
  <string>${LOG_DIR}/launchd.stdout.log</string>

  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/launchd.stderr.log</string>

  <key>ProcessType</key>
  <string>Background</string>
</dict>
</plist>
EOF

chmod 644 "${PLIST_PATH}"
chmod +x "${WRAPPER_PATH}"

launchctl bootout "gui/$(id -u)/${AGENT_ID}" >/dev/null 2>&1 || true
launchctl bootstrap "gui/$(id -u)" "${PLIST_PATH}"
launchctl enable "gui/$(id -u)/${AGENT_ID}"
launchctl kickstart -k "gui/$(id -u)/${AGENT_ID}"

echo "installed ${AGENT_ID}"
echo "plist: ${PLIST_PATH}"
echo "logs: ${LOG_DIR}"
