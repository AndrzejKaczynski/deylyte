# EMS SaaS — Onboarding Flow (Option B)

> Context: see `docs/PLANNING.md` for full architecture and `docs/architecture.svg` for the system diagram.
> This is a focused follow-up prompt. Do not re-plan the full architecture.
> Implement the PWA-first onboarding flow described below.

---

## Problem

The Flutter PWA is unusable until the HA add-on is installed and has
phoned home at least once. Without the add-on active, Serverpod has
no inverter data and cannot execute schedules. A user who opens the
PWA first sees an empty dashboard — bad first impression.

## Solution — PWA-first onboarding with connection gate

The PWA guides the user through setup step by step and blocks
progression to the live dashboard until the add-on is confirmed
connected. The experience feels intentional, not broken.

---

## Onboarding screens (Flutter Web)

### Screen 1 — Register / log in
- Standard email + password registration via Serverpod auth
- On success → Screen 2

### Screen 2 — License key entry
- Input field for license key
- On submit → POST to Serverpod license validation endpoint
- If valid → store key in Flutter secure storage, advance to Screen 3
- If invalid → show clear error ("Key not found or already used")
- Beta users receive their key via email from the admin panel

### Screen 3 — Add-on installation guide
- Step-by-step instructions rendered in Flutter:
  1. Install HACS on Home Assistant (link to hacs.xyz)
  2. Add our GitHub repo as a custom HACS repository (show repo URL)
  3. Install the EMS add-on from HACS
  4. Open the add-on config and enter:
     - License key (pre-filled, copyable)
     - Solarman dongle IP address
     - Solarman dongle serial number
  5. Start the add-on
- Below the steps: live connection status widget (see below)
- User cannot skip this screen — no "skip" button

### Screen 4 — Waiting for add-on (connection status widget)
- Shown inline at the bottom of Screen 3
- Polls `GET /api/device/status` every 5 seconds
- States:
  - Waiting: spinner + "Waiting for add-on to connect..."
  - Connected: green indicator + "Add-on connected! Loading your dashboard..."
    → automatically navigates to Dashboard after 2 seconds
  - Error: "Something went wrong — check the add-on logs"
- The polling stops and auto-advances on first successful connection
- If user leaves and comes back later (already connected), skip
  straight to Dashboard on login

---

## Serverpod endpoints required

### `GET /api/device/status`
- Auth: JWT (logged-in user)
- Returns:
```json
{
  "connected": true,
  "lastSeenAt": "2026-03-21T14:00:00Z",
  "inverterReachable": true
}
```
- `connected: true` when Serverpod has received at least one telemetry
  payload from this user's add-on in the last 5 minutes
- `inverterReachable: true` when the last telemetry payload had valid
  inverter state (not an error/timeout from pysolarmanv5)

### `POST /api/license/validate`
- Auth: none (pre-login)
- Body: `{ "licenseKey": "XXX-XXX-XXX" }`
- Returns: `{ "valid": true, "tier": "beta_free" }`
- On success: associates license key with the user account in RDS

### Existing telemetry ingest endpoint
- The add-on already POSTs telemetry to Serverpod (see PLANNING.md)
- When telemetry is received, update a `last_seen_at` timestamp on
  the device record in RDS — this is what `/api/device/status` reads

---

## RDS schema addition

Add to the existing `devices` table (or create if not yet existing):

```
devices
  id                uuid primary key
  user_id           uuid references users(id)
  hashed_serial     text unique        -- sha256 of dongle serial
  license_key       text references license_keys(key)
  last_seen_at      timestamptz        -- updated on every telemetry POST
  last_inverter_ok  boolean            -- true if last telemetry had valid state
  created_at        timestamptz
```

---

## Flutter routing logic

```
App start
  └─ Not logged in → Screen 1 (Register/Login)
  └─ Logged in, no license key → Screen 2 (License key entry)
  └─ Logged in, license key valid, device never connected → Screen 3 (Install guide)
  └─ Logged in, license key valid, device connected → Dashboard
```

Check device connection status on every app launch (not just first time).
If a previously connected add-on stops reporting for >10 minutes,
show a non-blocking banner on the Dashboard:
"Add-on offline — inverter data may be stale" with a link to
troubleshooting docs. Do not kick the user back to onboarding.

---

## Add-on side — no changes needed

The add-on already:
- Validates its license key on startup
- POSTs telemetry to Serverpod every 30–60s

The `last_seen_at` update happens server-side when telemetry is
received — the add-on needs no changes.

---

## What I need from you

1. Implement the four onboarding screens in Flutter Web
   - Use Riverpod for state management (consistent with PLANNING.md)
   - Connection status widget polls every 5s, auto-advances on success
   - License key pre-filled and copyable on Screen 3

2. Implement the two new Serverpod endpoints
   - `GET /api/device/status`
   - `POST /api/license/validate`
   - Update the telemetry ingest handler to write `last_seen_at`

3. Update the Flutter router
   - Add the routing logic described above
   - Offline banner on Dashboard when add-on goes silent

4. Update the RDS schema
   - Add `last_seen_at` and `last_inverter_ok` to the devices table
   - Serverpod model `.spy.yaml` definition for the devices table

Do not touch any other part of the codebase outside of these four areas.
