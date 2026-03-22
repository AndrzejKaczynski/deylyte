#!/bin/bash
set -e
HA_HOST="${HA_HOST:-192.168.1.138}"
HA_USER="${HA_USER:-hassio}"
rsync -avz -e "ssh -p 22" "$(dirname "$0")/../ha_addon/" "$HA_USER"@"$HA_HOST":/addons/deylyte_ems/
echo "Sync done. Restart the DeyLyte EMS add-on from HA → Settings → Add-ons → DeyLyte EMS → Restart."
