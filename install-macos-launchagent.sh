#!/bin/zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENT_ID="local.openwebui.launcher"
LAUNCH_AGENTS_DIR="${HOME}/Library/LaunchAgents"
APP_SUPPORT_DIR="${HOME}/Library/Application Support/OpenWebUILauncher"
PLIST_PATH="${LAUNCH_AGENTS_DIR}/${AGENT_ID}.plist"
LOG_DIR="${HOME}/Library/Logs/OpenWebUILauncher"

mkdir -p "${LAUNCH_AGENTS_DIR}" "${LOG_DIR}" "${APP_SUPPORT_DIR}"

cat > "${PLIST_PATH}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${AGENT_ID}</string>

  <key>ProgramArguments</key>
  <array>
    <string>/opt/homebrew/bin/open-webui</string>
    <string>serve</string>
    <string>--host</string>
    <string>127.0.0.1</string>
    <string>--port</string>
    <string>8080</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <true/>

  <key>WorkingDirectory</key>
  <string>${APP_SUPPORT_DIR}</string>

  <key>EnvironmentVariables</key>
  <dict>
    <key>HOME</key>
    <string>${HOME}</string>
    <key>USER</key>
    <string>${USER}</string>
    <key>LOGNAME</key>
    <string>${USER}</string>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    <key>LANG</key>
    <string>en_US.UTF-8</string>
    <key>LC_ALL</key>
    <string>en_US.UTF-8</string>
    <key>PYTHONUNBUFFERED</key>
    <string>1</string>
    <key>DATA_DIR</key>
    <string>${APP_SUPPORT_DIR}/data</string>
  </dict>

  <key>StandardOutPath</key>
  <string>${LOG_DIR}/launchd.stdout.log</string>

  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/launchd.stderr.log</string>

</dict>
</plist>
EOF

chmod 644 "${PLIST_PATH}"

launchctl bootout "gui/$(id -u)/${AGENT_ID}" >/dev/null 2>&1 || true
rm -f "${LOG_DIR}/launchd.stdout.log" "${LOG_DIR}/launchd.stderr.log"
rm -f "${LOG_DIR}/open-webui.stdout.log" "${LOG_DIR}/open-webui.stderr.log"
launchctl bootstrap "gui/$(id -u)" "${PLIST_PATH}"
launchctl enable "gui/$(id -u)/${AGENT_ID}"
launchctl kickstart -k "gui/$(id -u)/${AGENT_ID}"

echo "installed ${AGENT_ID}"
echo "plist: ${PLIST_PATH}"
echo "logs: ${LOG_DIR}"
