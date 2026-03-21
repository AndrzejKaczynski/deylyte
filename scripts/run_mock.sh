#!/bin/bash
cd "$(dirname "$0")/../deyelyte_flutter"
flutter run -d chrome \
  --dart-define=BYPASS_ONBOARDING=true \
  --dart-define=USE_MOCK_DATA=true
