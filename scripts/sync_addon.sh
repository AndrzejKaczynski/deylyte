#!/bin/bash
set -e
HA_HOST="${HA_HOST:-192.168.1.138}"
HA_USER="${HA_USER:-hassio}"

echo "Syncing addon files to $HA_HOST…"
rsync -avz -e "ssh -p 22" "$(dirname "$0")/../ha_addon/" "$HA_USER"@"$HA_HOST":/addons/deylyte_ems/

if [ "${BUILD:-0}" = "1" ]; then
  echo "Running Docker build on HA host (output below)…"
  ssh -p 22 "$HA_USER"@"$HA_HOST" \
    "cd /addons/deylyte_ems && sudo docker build --build-arg BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest --no-cache . 2>&1"
else
  echo "Sync done. To also build and see full output: BUILD=1 $0"
  echo "Or rebuild manually: HA → Settings → Add-ons → DeyLyte EMS → ⋮ → Rebuild"
fi
