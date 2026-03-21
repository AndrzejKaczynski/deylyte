#!/bin/bash
set -e
rsync -avz "$(dirname "$0")/../ha_addon/" root@homeassistant.local:/addons/deylyte/
echo "Restarting DeyLyte add-on..."
ssh root@homeassistant.local "ha addons restart local_deylyte"
