# openwebuilauncher

Minimal macOS launchd setup for running `open-webui serve` silently at user login.

## files

- `open-webui-launch.sh`: wrapper that starts `open-webui serve` and writes logs
- `install-macos-launchagent.sh`: installs and starts the user launch agent
- `uninstall-macos-launchagent.sh`: removes the launch agent

## install

```bash
./install-macos-launchagent.sh
```

## logs

Logs are written to `~/Library/Logs/OpenWebUILauncher`.
