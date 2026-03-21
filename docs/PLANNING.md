# EMS SaaS — Claude Code Planning Prompt

> See `docs/architecture.svg` for the full system architecture diagram.
> Enter planning mode — do not write any code yet. Analyze the existing
> codebase, ask clarifying questions if needed, then produce a detailed
> architecture and migration plan.

---

## Language & framework — critical constraint

The ENTIRE stack is written in Dart:
- **Backend**: Serverpod (open-source, Dart backend framework for Flutter)
- **Frontend**: Flutter Web (compiled to static HTML/JS/CSS)
- **Generated client**: Serverpod auto-generates a type-safe Dart client
  from endpoint definitions — no manual API glue code
- **HA add-on agent**: Python (only exception — required by the
  SolarmanV5/pysolarmanv5 library and HA ecosystem conventions)

Do NOT suggest Node.js, Go, Python, or any other language for the
backend or frontend. All new code must be Dart/Flutter.

---

## Product vision

A SaaS EMS (Energy Management System) for Deye hybrid inverters.
Key design principles:
- ALL inverter data and credentials stay on the user's local network
- The cloud backend handles ONLY: optimization logic, licensing,
  billing, and anonymized telemetry
- The user-facing UI is a Flutter Web app hosted on S3 + CloudFront
- The HA add-on is the local agent — talks to the inverter locally
  and exposes the Flutter UI via an HA Webpage sidebar panel
- Business logic (optimization algorithms) lives on AWS so we can
  redeploy without releasing a new HA add-on version

---

## Current state

- EMS app partially built on AWS
- Currently uses Deye Cloud API (appId + appSecret) — must be removed
- Deye Cloud ToS explicitly prohibits reselling — hard blocker
- Codebase already uses Serverpod + Flutter — review what exists

---

## Target architecture

See `docs/architecture.svg` for the full system diagram.

### 1. Home Assistant Add-on (HACS distribution)

- Distributed via HACS (GitHub repo) — NOT the official HA store
- Written in **Python** (pysolarmanv5 requirement)
- Communicates with Deye inverter locally via SolarmanV5 protocol
  over TCP port 8899 — uses the Solarman WiFi dongle that ships
  with most Deye inverters (no RS485 cable needed)
- Responsibilities:
  - Poll inverter state every 30–60s via SolarmanV5
  - Execute optimization schedules/commands received from Serverpod
  - Validate license key against Serverpod on startup + periodically
  - Send anonymized telemetry to Serverpod API (no PII, no raw creds)
  - Expose HA sidebar Webpage panel loading Flutter app from CloudFront
  - Store NOTHING sensitive except: license key + dongle IP/serial
    (local to user's device only)
- Add-on config (set by user in HA UI):
  - License key (validated against Serverpod)
  - Solarman dongle IP address or auto-discovery
  - Solarman dongle serial number

### 2. AWS Backend (Serverpod)

- **Serverpod API server**
  - EC2 with Terraform + GitHub Actions CI/CD
  - Dart endpoints (type-safe, auto-generates Flutter client)
  - Handles: license validation, telemetry ingest, schedule delivery,
    user auth, Stripe webhook processing
- **Optimization engine**
  - Dart code running as Serverpod future calls (scheduled tasks)
  - Energy scheduling logic: charge/discharge windows, power limits
  - Redeployable independently — no HA add-on release required
- **RDS PostgreSQL** (Serverpod's required DB)
  - users · license keys · Stripe subscription state · schedules
  - Anonymized/hashed device identifiers only — no raw energy data
- **Redis** (Serverpod optional, enable in config)
  - License key validation cache (reduce DB hits on every add-on check)
  - Session state · add-on heartbeat tracking
- **S3 + CloudFront**
  - Flutter Web static build (flutter build web)
  - Global CDN, HTTPS, served to both HA sidebar panel and mobile PWA
- **Stripe webhooks**
  - Subscription lifecycle events → auto license key management
  - Handled as a Serverpod endpoint

### 3. Flutter Web App

- **Dart + Flutter Web** compiled to static build on S3 + CloudFront
- Calls Serverpod API using the **auto-generated Dart client package**
  (type-safe, no manual REST boilerplate)
- Accessible two ways:
  1. Embedded in HA as a Webpage dashboard sidebar panel (CloudFront URL)
  2. Standalone PWA on mobile (same URL, configured as installable PWA)
- Key screens:
  - Dashboard — real-time inverter state (relayed via Serverpod)
  - Energy charts — consumption, production, battery SOC over time
  - Schedule editor — manage charge/discharge windows
  - Account & billing — subscription management, Stripe portal
  - Settings — license key, add-on connection status

### 4. Admin Panel (planned — note for now, do not implement)

- Internal Flutter Web panel for operators
- Manage beta users: create/revoke license keys, set tiers
- View anonymized fleet telemetry and aggregate stats
- Manage Stripe subscriptions manually
- Same Serverpod API, admin role/permission layer

---

## Beta testing flow

1. Operator creates beta user in admin panel
2. System generates license key with `tier = beta_free` (no Stripe charge)
3. User registers on Flutter web app, receives license key
4. User installs add-on via HACS, enters license key + dongle IP in HA
5. Add-on validates key with Serverpod → activates → starts polling
6. User sees Flutter UI in HA sidebar (or as standalone PWA)

---

## Data contract between add-on and Serverpod

Design this carefully.

**Add-on → Serverpod (POST telemetry endpoint)**
```json
{
  "deviceId": "<sha256 of dongle serial>",
  "timestamp": "<iso8601>",
  "inverterState": {
    "batterySOC": 82,
    "gridPowerW": -1200,
    "pvPowerW": 3400,
    "loadPowerW": 2100,
    "batteryPowerW": -100
  }
}
```
No PII. No home network info. No inverter credentials.

**Serverpod → Add-on (schedule response)**
```json
{
  "schedules": [
    {
      "startTime": "22:00",
      "endTime": "06:00",
      "mode": "charge",
      "targetSOC": 100,
      "maxPowerW": 3000
    }
  ],
  "licenseValid": true,
  "nextCheckIn": 3600
}
```

**Auth between add-on and Serverpod:**
License key sent as `Authorization: Bearer <license_key>` header.
No user credentials ever stored in the add-on.

---

## GDPR/RODO posture

- Serverpod/AWS stores NO inverter credentials
- Serverpod/AWS stores NO raw energy consumption data
- Serverpod/AWS stores NO home network information
- Only PII on AWS: user email + hashed device identifier
- Data stored locally on user device: license key, dongle IP/serial
- This minimizes our role as data processor significantly

---

## Infrastructure — decisions already made

| Service | Purpose |
|---|---|
| Serverpod on EC2 (Terraform) | API + optimization engine |
| Terraform + GitHub Actions | Infrastructure as code + CI/CD |
| RDS PostgreSQL | Main database (Serverpod requirement) |
| Redis | Cache + sessions (Serverpod optional, add later) |
| S3 + CloudFront | Flutter Web hosting |
| Stripe | Billing + webhooks |
| HACS (GitHub repo) | Add-on distribution |

Do NOT suggest App Runner or Lambda — Serverpod uses EC2 + its own
Terraform scripts for AWS deployment. This is already decided.

---

## Bootstrap / beta infrastructure

Start with the absolute minimum to keep costs ~$26–38/month.
Do NOT provision a load balancer initially — use an Elastic IP
assigned to the EC2 instance with Caddy handling HTTPS/TLS
(Let's Encrypt) directly on the instance.

Specific starting sizes:
- EC2: t4g.micro (upgrade to t4g.small when first paid users arrive)
- RDS: db.t4g.micro · Single-AZ (upgrade to Multi-AZ before going paid)
- Redis: skip for now — license checks hit RDS directly, fine at <50 users
- ALB: skip for now — add via Terraform when autoscaling is needed
- Elastic IP: assign to EC2 instance (free while associated)
- Caddy: runs on the instance, auto-manages Let's Encrypt certs

All of the above are Terraform variable changes only — zero
architecture rework required to scale up. Flag each of these
decisions with a TODO comment in the Terraform config so they
are easy to find and flip later.

---

## Serverpod project structure (standard)

```
my_project/
  my_project_server/     <- Dart · Serverpod endpoints, models, future calls
  my_project_client/     <- Dart · auto-generated client (do not edit manually)
  my_project_flutter/    <- Dart · Flutter Web frontend
  ha_addon/              <- Python · HA add-on (pysolarmanv5 agent)
  docs/
    architecture.svg     <- System architecture diagram (reference this)
    PLANNING.md          <- This file
```

---

## What I need from you

### 1. Codebase audit
- Identify all Deye Cloud API integration points to remove
- Identify existing Serverpod endpoints to keep vs rework
- Flag any stored credentials or PII that needs to be handled
  differently
- Check current Flutter screens — what maps to the new architecture

### 2. HA add-on (Python) architecture
- Valid HACS-compatible add-on file structure
- SolarmanV5 polling loop with error handling + reconnect
- License key validation flow (startup + periodic re-check via
  Serverpod endpoint)
- Telemetry payload format and upload cadence
- Schedule receipt and execution against inverter registers
- How to register the Flutter CloudFront URL as an HA Webpage panel
- `config.yaml` / options flow for the HA add-on UI

### 3. Serverpod endpoint map
- Full list of endpoints needed (with request/response types in Dart)
- Serverpod model definitions (`.spy.yaml` files) for DB schema
- Future call definitions for the optimization engine
- Stripe webhook endpoint + license lifecycle handlers
- Auth strategy (Serverpod has built-in auth module — use it)

### 4. Flutter Web app structure
- State management recommendation (Riverpod recommended with Serverpod)
- Screen map and navigation structure
- How to consume the Serverpod generated client correctly
- PWA configuration (`manifest.json`, service worker)
- How to handle auth token passing for the HA sidebar panel URL

### 5. Terraform / infrastructure setup
- Serverpod Terraform config with beta sizing (t4g.micro, db.t4g.micro)
- Caddy config on the EC2 instance for HTTPS without ALB
- Elastic IP association
- TODO comments marking each beta shortcut for future upgrade
- GitHub Actions CI/CD wiring for Serverpod deployments

### 6. Phased delivery plan

| Phase | Scope |
|---|---|
| 1 | Strip Deye Cloud API · add SolarmanV5 local comms in Python add-on |
| 2 | HACS packaging · license key system · beta user flow |
| 3 | Serverpod endpoints for telemetry, schedules, auth |
| 4 | Flutter Web MVP — dashboard + schedule editor |
| 5 | Optimization engine (Serverpod future calls) |
| 6 | Stripe billing integration |
| 7 | Admin panel (Flutter Web, admin role) |
| 8 | Production upgrade — ALB, Multi-AZ DB, Redis, t4g.small |

---

Start by reading the existing codebase structure, then produce the
full plan. Ask clarifying questions if the codebase reveals decisions
that conflict with the architecture above.
