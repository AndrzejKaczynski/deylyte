#!/bin/bash
cd "$(dirname "$0")/../deyelyte_flutter"
flutter run -d chrome \
  --dart-define=SERVERPOD_HOST=localhost \
  --dart-define=SERVERPOD_PORT=8080
