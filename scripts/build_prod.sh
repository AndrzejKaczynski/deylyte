#!/bin/bash
cd "$(dirname "$0")/../deyelyte_flutter"
flutter build web \
  --dart-define=SERVERPOD_HOST=api.deylyte.com \
  --dart-define=SERVERPOD_PORT=443
