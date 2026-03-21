# Pre-Beta Checklist

- [ ] `serverpod generate` runs without errors; `deyelyte_client` regenerated
- [ ] `serverpod create-migration` applied; database schema matches models
- [ ] `flutter analyze` passes with zero errors on all modified files
- [ ] Onboarding flow: unauthenticated → `/auth`; authenticated, no license key → `/onboarding/license`; license key, no device row → `/onboarding/setup`; device connected → `/`
- [ ] Invalid license key shows error banner; valid key stores to secure storage and navigates to setup
- [ ] Connection widget polls every 5 s; auto-advances to `/` when add-on connects
- [ ] Settings screen: no Deye toggle visible; SolarmanV5 status row shows "Not configured"; pricing source has 4 options (Pstryk / RCE / Fixed / Manual)
- [ ] Dashboard: EMS Status card visible in sidebar; KPI strip shows `--` when no telemetry (no crashes); offline banner appears when add-on was seen before but is now offline
- [ ] Schedule screen: date in header reflects today's date; Strategy Summary shows active price source; forecast chart renders empty bars when stub returns `[]`
- [ ] History screen: range toggle re-fetches data; currency shows `zł`; Carbon Offset shows `—`
- [ ] `scripts/run_mock.sh` launches app without server (mock data visible on dashboard)
- [ ] `scripts/run_dev.sh` connects to local Serverpod and completes onboarding flow end-to-end
- [ ] `scripts/build_prod.sh` produces a web build with no debug flags
