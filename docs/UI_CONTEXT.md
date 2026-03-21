# DeyLyte — Existing UI Context & Screen Rework Guide

> Context: see `docs/PLANNING.md` for full architecture,
> `docs/architecture.svg` for the system diagram,
> `docs/ONBOARDING.md` for the onboarding flow spec.
> This prompt documents the current UI state and what to change on each screen.
> Do not re-plan the architecture. Only touch what is explicitly listed below.

---

## App identity

- App name: **DeyLyte**
- Design language: dark theme, deep navy/charcoal backgrounds, green
  accent for active/positive states, amber for warnings, sidebar nav
- The visual style and layout structure must be preserved across all screens
- Sidebar navigation: Dashboard · Schedule · History · Settings · Sign Out

---

## Current screen inventory & decisions

### Settings screen — KEEP, minor changes only

This is the most complete screen. Preserve the layout, card structure,
and all existing sections. Make only these targeted changes:

**Change 1 — Replace "Deye Cloud Sync" integration card**
Currently shows:
  `Deye Cloud Sync · Not configured · [toggle]`
Replace with:
  `Local Inverter (SolarmanV5) · [status text] · [status indicator]`
- Status text options: "Add-on connected", "Add-on offline", "Not configured"
- Status indicator: green dot (connected), amber dot (offline), grey dot
  (not configured)
- Tapping/clicking the card opens a small detail panel showing:
  - Last seen timestamp
  - Dongle IP (read-only, set in HA add-on config)
  - Link to HACS add-on repo
- The toggle is removed — connection is managed by the add-on, not here

**Change 2 — Update the onboarding banner**
Currently shows:
  "Connect your Deye inverter to enable EMS control. After connecting,
  a 7-day baseline collection period begins."
Replace with dynamic content based on add-on connection status:
  - Not connected: "Install the DeyLyte add-on in Home Assistant to
    enable EMS control." with a "Setup guide →" link that opens the
    onboarding flow (see ONBOARDING.md)
  - Connected, baseline collecting: "Add-on connected. Collecting
    7-day baseline — EMS optimization starts [date]."
  - Connected, EMS active: hide the banner entirely

**Change 3 — Pricing Source**
Keep Pstryk · RCE · Fixed tabs exactly as-is. These are valid
integrations that will be wired to the optimization engine later.
Add a fourth option: "Manual" — fixed buy/sell price the user enters
themselves. Useful for beta users whose tariff isn't in the list.

**Everything else on Settings — no changes.**
Battery Reserve slider, Hardware Setup, Battery Specifications,
Solcast Forecasting, Pstryk Pricing Hub, Fallback PV Location,
Danger Zone — all stay exactly as currently built.

---

### Dashboard screen — REWORK

Keep the overall card grid layout and dark aesthetic. Replace content
as follows.

**Keep:**
- Battery SoC metric card (top row) — wire to real telemetry
- Net Balance metric card — wire to real data (use PLN or user currency)
- Grid Status metric card — wire to real telemetry
- Solar Yield metric card — wire to real telemetry
- Consumption Trends chart (bottom) — wire to real telemetry history
- Power Flow diagram node layout (Solar → Home Load → Battery → Grid)
  — keep the animated node diagram, wire to real telemetry values

**Remove:**
- Appliance Status panel (Dishwasher, Tesla Wallbox, Heat Pump)
  SolarmanV5 does not expose individual appliance loads.
  Replace with: **EMS Status card** (same position, right column)
  showing:
  - Current EMS mode (Standby / Optimizing / Charging / Discharging)
  - Next scheduled action + time (e.g. "Charge at 22:00 · in 4h")
  - Battery reserve level (from Settings)
  - Link to Schedule screen

**Wire all values to Serverpod:**
- All metric cards poll `GET /api/device/telemetry/latest`
- Consumption Trends polls `GET /api/device/telemetry/history?range=24h`
- Power Flow node values come from latest telemetry payload
- EMS Status card polls `GET /api/schedule/current`
- Refresh interval: 30 seconds (match add-on poll interval)
- When add-on is offline: show stale data with a timestamp
  ("Last updated 4 min ago") — do not show empty state

---

### Schedule screen — REWORK structure, keep visual style

Keep the dark card aesthetic, the 24-Hour Forecast chart layout,
and the Power Allocation Flow card list. Rework the data sources
and remove features that have no backend yet.

**Keep:**
- 24-Hour Forecast bar chart (price tiers + Battery SoC line)
  Wire to: `GET /api/schedule/forecast` from Serverpod
- Power Allocation Flow event cards (Off-Peak Pre-charge, Solar
  Harvest, High-Yield Feed-in, Evening Peak Shaving)
  Wire to: `GET /api/schedule/events`
  Statuses: Completed · In Progress · Upcoming · Planned

**Remove / simplify:**
- "Smart Strategy / AI Kinetic · Learning User Behaviour" panel
  Replace with: **Strategy Summary card** showing:
  - Active strategy name (e.g. "Price-optimized" / "Solar-first" /
    "Manual")
  - Weather input if Solcast is configured, otherwise "No weather data"
  - Historical basis: "Based on [N] days of data" or "Baseline
    collecting ([N]/7 days)"
  - Est. Net Profit range — keep this, wire to Serverpod calculation

- "Upcoming Events" sidebar list — keep, wire to `GET /api/schedule/events`

**Top bar:**
- Keep "Est. Net Profit" chip — wire to real value from Serverpod
- Remove "Real-time optimization for Today, Oct 24" — replace with
  actual current date from device

---

### History screen — REWORK data sources, keep layout

The layout and chart structure are good. Wire everything to real data.

**Keep:**
- Price Velocity · Net Revenue · Peak Load · Green Mix metric cards
  Wire to: `GET /api/history/summary?range=30d` (or 7d/90d)
- Market Arbitrage & Storage chart — wire to history data
- Yield vs Expenditure chart — wire to history data
- Total Net Profit / Total Savings / Storage Efficiency / Carbon
  Offset / Peak Demand sidebar — wire to history summary
- Recent Market Events list — wire to `GET /api/history/events`
- 7 days / 30 days / 90 days range toggle — wire to API range param

**Currency:**
- Currently shows USD ($). Change to display user's configured
  currency — default PLN for Polish users, configurable in Settings
  (add currency field to Settings if not present)

**Remove / flag:**
- Carbon Offset (1.2 Tons) — this requires emissions factor data
  per grid region. Flag as `// TODO: requires grid carbon intensity
  API integration` and show "—" until implemented

---

## Screens to ADD (from ONBOARDING.md)

Build the four onboarding screens as specified in `docs/ONBOARDING.md`.
They must match the DeyLyte dark aesthetic exactly:
- Same sidebar (collapsed/hidden during onboarding — user hasn't
  reached the main app yet)
- Same card style, typography, and color tokens
- Progress indicator at the top showing step 1/2/3
- The connection status widget on Screen 3 uses a pulsing green dot
  animation when waiting, matching the existing "Charging" indicator
  style on the Dashboard Battery SoC card

---

## Data dependencies summary

| Screen | Needs | Endpoint |
|---|---|---|
| Dashboard | Latest telemetry | `GET /api/device/telemetry/latest` |
| Dashboard | 24h history | `GET /api/device/telemetry/history?range=24h` |
| Dashboard | Current schedule | `GET /api/schedule/current` |
| Schedule | Forecast | `GET /api/schedule/forecast` |
| Schedule | Events | `GET /api/schedule/events` |
| History | Summary | `GET /api/history/summary?range=Nd` |
| History | Events | `GET /api/history/events` |
| Settings | Add-on status | `GET /api/device/status` |
| Onboarding | Device status | `GET /api/device/status` |
| Onboarding | License validate | `POST /api/license/validate` |

All endpoints must be defined in Serverpod and added to the
endpoint map in `docs/PLANNING.md`.

---

## What I need from you

1. **Settings screen** — apply the three targeted changes above,
   nothing else

2. **Dashboard screen** — remove Appliance Status, add EMS Status
   card, wire all values to Serverpod endpoints

3. **Schedule screen** — replace Smart Strategy panel with Strategy
   Summary card, wire all data to Serverpod endpoints

4. **History screen** — wire all data to Serverpod endpoints,
   swap currency to user setting, flag Carbon Offset as TODO

5. **Onboarding screens** — implement as per `docs/ONBOARDING.md`,
   matching DeyLyte visual style

6. **Serverpod endpoints** — stub all endpoints in the table above
   with correct Dart types and `.spy.yaml` model definitions.
   Return mock/empty data for now — real optimization logic comes later.

Do not redesign any screen from scratch. Preserve the existing
component structure, color tokens, and layout. Only change what
is explicitly listed.
