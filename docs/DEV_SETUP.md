# DeyLyte — Local Development Setup

> Context: see `docs/PLANNING.md` for full architecture.
> This prompt sets up the local development environment so the full
> stack can be tested without any public release — no HACS, no AWS,
> no CloudFront needed during development.

---

## Goal

Enable this local dev loop:

```
Serverpod API    → localhost:8080   (Dart, docker-compose)
Flutter Web app  → localhost:3000   (flutter run -d chrome)
HA Add-on        → local add-on     (installed from /addons/ on HA)
Deye inverter    → real device      (SolarmanV5 over local network)
```

The add-on on HA talks to the Serverpod instance running on the
developer's machine via local network IP. The Flutter app talks to
the same local Serverpod. No AWS, no HACS, no public URLs required.

---

## 1. Serverpod — local environment

Serverpod already generates `docker-compose.yaml` in the server
directory. No changes needed there.

Add a `config/development.yaml` override (if not already present)
that matches the default Serverpod dev config. Confirm:
- API server on port 8080
- Insights server on port 8081
- Postgres connecting to the Docker container
- Redis disabled in development (matches our beta decision to skip it)

Add a `.env.local` file (git-ignored) for any secrets needed locally:
```
STRIPE_WEBHOOK_SECRET=whsec_test_...
STRIPE_SECRET_KEY=sk_test_...
```

Running locally:
```bash
cd my_project_server
docker compose up -d        # start Postgres
dart bin/main.dart          # start Serverpod API
```

---

## 2. Flutter app — environment switching + onboarding bypass

### Environment configuration

Create `lib/config/app_config.dart`:

```dart
class AppConfig {
  static const String serverpodHost = String.fromEnvironment(
    'SERVERPOD_HOST',
    defaultValue: 'localhost',
  );

  static const int serverpodPort = int.fromEnvironment(
    'SERVERPOD_PORT',
    defaultValue: 8080,
  );

  static const bool bypassOnboarding = bool.fromEnvironment(
    'BYPASS_ONBOARDING',
    defaultValue: false,
  );

  static const bool useMockData = bool.fromEnvironment(
    'USE_MOCK_DATA',
    defaultValue: false,
  );
}
```

All flags are compile-time constants. They cannot be `true` in a
production build unless explicitly passed at build time — safe by
design.

### Run scripts

Add these to the project root `Makefile` or `scripts/` folder:

```bash
# scripts/run_dev.sh — full local dev with real local Serverpod
flutter run -d chrome \
  --dart-define=SERVERPOD_HOST=localhost \
  --dart-define=SERVERPOD_PORT=8080

# scripts/run_mock.sh — UI development only, no backend needed
flutter run -d chrome \
  --dart-define=BYPASS_ONBOARDING=true \
  --dart-define=USE_MOCK_DATA=true

# scripts/build_prod.sh — production build for S3/CloudFront
flutter build web \
  --dart-define=SERVERPOD_HOST=api.deylyte.com \
  --dart-define=SERVERPOD_PORT=443
```

### Mock data layer

When `USE_MOCK_DATA=true`, all Serverpod client calls must return
mock responses instead of hitting the network. Implement a
`MockServerpodClient` that mirrors the real generated client
interface and returns hardcoded realistic data:

```dart
// lib/data/mock/mock_telemetry.dart
final mockLatestTelemetry = TelemetrySnapshot(
  batterySOC: 84,
  gridPowerW: 0,
  pvPowerW: 3200,
  loadPowerW: 1800,
  batteryPowerW: -1400,
  timestamp: DateTime.now(),
);
```

Wire this in a repository layer so the Flutter widgets never import
the Serverpod client directly — they import a repository interface
that switches between real and mock implementations based on
`AppConfig.useMockData`.

### Onboarding bypass

When `BYPASS_ONBOARDING=true`, the Flutter router skips the
onboarding screens and goes directly to the Dashboard. Implement
this check in the router:

```dart
// In your GoRouter or Navigator setup
if (AppConfig.bypassOnboarding) {
  return '/dashboard'; // skip to dashboard
}
// ... normal onboarding routing logic
```

---

## 3. HA Add-on — local installation (no HACS needed)

### Folder structure on HA

HA loads add-ons from `/addons/` on the host filesystem automatically.
No HACS, no GitHub repo, no public release needed.

Place the add-on at:
```
/addons/deylyte/
  config.yaml
  Dockerfile
  run.sh
  deylyte_addon/
    __init__.py
    addon.py
    solarman.py
    ...
```

It appears in HA under Settings → Add-ons → Local add-ons immediately.

### Add `api_url` to add-on config options

Add an `api_url` field to `config.yaml` so the add-on can point at
a local dev machine instead of production:

```yaml
# ha_addon/config.yaml
name: DeyLyte EMS
version: "0.1.0"
slug: deylyte
description: Local EMS agent for Deye inverters
arch:
  - aarch64
  - amd64
options:
  license_key: ""
  dongle_ip: ""
  dongle_serial: ""
  api_url: "https://api.deylyte.com"   # override for local dev
schema:
  license_key: str
  dongle_ip: str
  dongle_serial: str
  api_url: str
```

During local development, set `api_url` in the HA add-on config UI
to `http://192.168.1.XXX:8080` (your dev machine's local network IP).
In production, leave it as the default — Serverpod's production URL.

### Syncing add-on code during development

Option A — Samba share (easiest):
Install the Samba add-on in HA. Mount the HA filesystem on your
dev machine. Edit files directly, restart add-on from HA UI.

Option B — SSH + rsync (faster iteration):
```bash
# scripts/sync_addon.sh
rsync -avz ha_addon/ \
  root@homeassistant.local:/addons/deylyte/
```

Then restart the add-on via HA UI or:
```bash
ssh root@homeassistant.local \
  "ha addons restart local_deylyte"
```

Add `scripts/sync_addon.sh` to the project. Run it after every
change to the add-on code.

### Add-on logs

View real-time logs in HA UI under:
Settings → Add-ons → DeyLyte → Log tab

Or via SSH:
```bash
ssh root@homeassistant.local "journalctl -f SYSLOG_IDENTIFIER=deylyte"
```

---

## 4. Network diagram — local dev

```
Dev machine (192.168.1.100)
  ├─ Serverpod :8080
  ├─ Flutter :3000 (flutter run -d chrome)
  └─ Postgres :5432 (Docker)

HA instance (192.168.1.X)
  └─ DeyLyte add-on
       ├─ polls Deye inverter via SolarmanV5 (local TCP :8899)
       └─ POSTs telemetry to http://192.168.1.100:8080
            (api_url set in add-on config)

Browser (same machine or phone on same WiFi)
  └─ opens http://localhost:3000 (or http://192.168.1.100:3000)
       └─ Flutter app connects to Serverpod at localhost:8080
```

---

## 5. Pre-beta checklist (before sharing with testers)

These flags must be verified before any external tester receives
a build or HACS link:

- [ ] `BYPASS_ONBOARDING` is not passed in any production build script
- [ ] `USE_MOCK_DATA` is not passed in any production build script
- [ ] Add-on `api_url` default points to production Serverpod URL
- [ ] Add-on `api_url` is NOT hardcoded to a local IP
- [ ] Serverpod `config/production.yaml` does not reference localhost
- [ ] License key validation is enforced (not skipped) in production
- [ ] Flutter router onboarding gate is active in production builds

---

## What I need from you

1. **`lib/config/app_config.dart`** — implement as above

2. **Mock data layer** — create `lib/data/mock/` with mock
   implementations for all Serverpod endpoints used by the UI.
   Wire via a repository pattern so widgets never call Serverpod
   client directly.

3. **Run scripts** — create `scripts/run_dev.sh`, `scripts/run_mock.sh`,
   `scripts/build_prod.sh`, `scripts/sync_addon.sh`

4. **Add-on `config.yaml`** — add `api_url` option with production
   default. Update the add-on Python code to read `api_url` from
   options and use it for all Serverpod API calls.

5. **Router bypass** — implement `BYPASS_ONBOARDING` check in the
   Flutter router

6. **Pre-beta checklist** — add as `docs/PRE_BETA_CHECKLIST.md`
   with the items above as a markdown checkbox list

Do not change any business logic, Serverpod endpoints, or UI screens.
This prompt is purely dev tooling and environment configuration.
