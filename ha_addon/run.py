#!/usr/bin/env python3
"""
DeyLyte EMS Add-on
------------------
1. On startup: validates license with server → receives sync interval.
2. Captures current inverter control-register state as baseline for revert.
3. Reads inverter state via SolarmanV5 every syncInterval seconds.
4. POSTs telemetry to the DeyLyte backend.
5. Receives schedule + planning mode flag in the response.
6. Applies inverter commands only when NOT in planning mode.
7. If the response includes a new syncIntervalSeconds, stores it and adapts.
8. If the response includes stop=true (license expired/deactivated), reverts
   inverter to baseline and halts telemetry collection.

Traffic spreading: startup is delayed by a deterministic jitter derived from
the license key so that all devices do NOT hit the backend at the same time.
"""

import hashlib
import json
import logging
import os
import sys
import time
from datetime import datetime, timezone

import requests
from pysolarmanv5 import PySolarmanV5

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
log = logging.getLogger("deylyte")

_SYNC_CONFIG_PATH    = "/data/sync_config.json"
_INITIAL_STATE_PATH  = "/data/initial_inverter_state.json"
_DEFAULT_INTERVAL    = 300  # fallback when server unreachable at startup

# ── Config ────────────────────────────────────────────────────────────────────

def load_config() -> dict:
    """Load options from /data/options.json (HA add-on standard path)."""
    options_path = "/data/options.json"
    if not os.path.exists(options_path):
        # Fallback to env vars for local dev testing
        return {
            "license_key": os.environ.get("LICENSE_KEY", ""),
            "api_url": os.environ.get("API_URL", "http://localhost:8080"),
            "dongle_ip": os.environ.get("DONGLE_IP", ""),
            "dongle_serial": os.environ.get("DONGLE_SERIAL", ""),
        }
    with open(options_path) as f:
        return json.load(f)


def validate_config(cfg: dict) -> bool:
    missing = [k for k in ("license_key", "dongle_ip", "dongle_serial") if not cfg.get(k)]
    if missing:
        log.error("Missing required config: %s", ", ".join(missing))
        return False
    return True


# ── Sync interval (server-controlled) ────────────────────────────────────────

def load_sync_interval() -> int:
    """Read stored sync interval from disk, or return the default."""
    try:
        with open(_SYNC_CONFIG_PATH) as f:
            return int(json.load(f).get("syncIntervalSeconds", _DEFAULT_INTERVAL))
    except Exception:
        return _DEFAULT_INTERVAL


def save_sync_interval(seconds: int) -> None:
    with open(_SYNC_CONFIG_PATH, "w") as f:
        json.dump({"syncIntervalSeconds": seconds}, f)


# ── Jitter ────────────────────────────────────────────────────────────────────

def startup_jitter(license_key: str, interval: int) -> int:
    """
    Return a deterministic offset (0 .. interval-1 seconds) derived from the
    license key. Spreads devices evenly across the polling window so the
    backend never receives a thundering herd.
    """
    digest = int(hashlib.md5(license_key.encode()).hexdigest(), 16)
    return digest % interval


# ── Inverter ──────────────────────────────────────────────────────────────────

# Holding register addresses for Deye SG04LP3 (confirmed working via FC3)
# All reads use read_holding_registers (FC3) — Deye does not respond to FC4.
_REG_BATTERY_SOC    = 588   # % (0-100)
_REG_BATTERY_POWER  = 590   # W, signed int16 (positive = charging, negative = discharging)
_REG_GRID_POWER     = 625   # W, signed int16 (positive = import from grid, negative = export)
_REG_LOAD_POWER     = 653   # W
_REG_PV1_POWER      = 672   # W (string 1)
_REG_PV2_POWER      = 673   # W (string 2)
_REG_PV3_POWER      = 674   # W (string 3, 0 if not present)
_REG_CHARGE_CMD     = 240   # write: 1 = charge from grid, 0 = disable
_REG_SELL_CMD       = 243   # write: 1 = sell to grid, 0 = disable


def _s16(val: int) -> int:
    """Convert unsigned 16-bit register value to signed int16."""
    return val if val < 32768 else val - 65536


def read_inverter(dongle_ip: str, dongle_serial: int) -> dict | None:
    try:
        s = PySolarmanV5(dongle_ip, dongle_serial, port=8899, mb_slave_id=1, verbose=False)
        soc  = s.read_holding_registers(_REG_BATTERY_SOC, 1)[0]
        batt = _s16(s.read_holding_registers(_REG_BATTERY_POWER, 1)[0])
        grid = _s16(s.read_holding_registers(_REG_GRID_POWER, 1)[0])
        load = s.read_holding_registers(_REG_LOAD_POWER, 1)[0]
        pv   = (s.read_holding_registers(_REG_PV1_POWER, 1)[0] +
                s.read_holding_registers(_REG_PV2_POWER, 1)[0] +
                s.read_holding_registers(_REG_PV3_POWER, 1)[0])
        return {
            "batterySOC":    float(soc),
            "pvPowerW":      float(pv),
            "gridPowerW":    float(grid),
            "loadPowerW":    float(load),
            "batteryPowerW": float(batt),
        }
    except Exception as exc:
        log.warning("Failed to read inverter: %s", exc)
        return None


def read_inverter_control_state(dongle_ip: str, dongle_serial: int) -> dict | None:
    """Read the current charge/sell register states — saved as revert baseline."""
    try:
        s = PySolarmanV5(dongle_ip, dongle_serial, port=8899, mb_slave_id=1, verbose=False)
        charge = s.read_holding_registers(_REG_CHARGE_CMD, 1)[0]
        sell   = s.read_holding_registers(_REG_SELL_CMD, 1)[0]
        return {"chargeFromGrid": bool(charge), "sellToGrid": bool(sell)}
    except Exception as exc:
        log.warning("Failed to read inverter control state: %s", exc)
        return None


def apply_schedule(dongle_ip: str, dongle_serial: int, commands: dict) -> None:
    """Write charge/sell commands to the inverter via holding registers."""
    try:
        s = PySolarmanV5(dongle_ip, dongle_serial, port=8899, mb_slave_id=1, verbose=False)
        if "chargeFromGrid" in commands:
            s.write_holding_register(_REG_CHARGE_CMD, 1 if commands["chargeFromGrid"] else 0)
        if "sellToGrid" in commands:
            s.write_holding_register(_REG_SELL_CMD, 1 if commands["sellToGrid"] else 0)
        log.info("Applied commands: %s", commands)
    except Exception as exc:
        log.warning("Failed to apply schedule: %s", exc)


def revert_inverter(dongle_ip: str, dongle_serial: int) -> None:
    """Restore the inverter to the state captured at add-on startup."""
    try:
        with open(_INITIAL_STATE_PATH) as f:
            baseline = json.load(f)
        log.info("Reverting inverter to baseline: %s", baseline)
        apply_schedule(dongle_ip, dongle_serial, baseline)
    except Exception as exc:
        log.warning("Failed to revert inverter (no baseline saved?): %s", exc)


# ── Backend ───────────────────────────────────────────────────────────────────

def fetch_license(api_url: str, license_key: str) -> dict:
    """
    Call license/validate on the server to obtain the sync interval assigned
    to this license tier. Returns the parsed response dict, or {} on failure.
    """
    try:
        resp = requests.post(
            f"{api_url}/license/validate",
            json={"licenseKey": license_key},
            timeout=10,
        )
        resp.raise_for_status()
        raw = resp.json()
        return raw if isinstance(raw, dict) else json.loads(raw)
    except Exception as exc:
        log.warning("Failed to fetch license info: %s", exc)
        return {}


def post_telemetry(api_url: str, license_key: str, device_id: str, telemetry: dict) -> dict | None:
    payload = {
        "method": "ingest",
        "licenseKey": license_key,
        "deviceId": device_id,
        "timestamp": datetime.now(timezone.utc).isoformat(),
        **telemetry,
    }
    try:
        resp = requests.post(
            f"{api_url}/telemetry",
            json=payload,
            timeout=10,
        )
        resp.raise_for_status()
        raw = resp.json()
        # Serverpod double-encodes String return types — unwrap if needed
        return raw if isinstance(raw, dict) else json.loads(raw)
    except Exception as exc:
        log.warning("Failed to POST telemetry: %s", exc)
        return None


# ── Main loop ─────────────────────────────────────────────────────────────────

def main() -> None:
    cfg = load_config()
    if not validate_config(cfg):
        sys.exit(1)

    license_key   = cfg["license_key"]
    api_url       = cfg["api_url"].rstrip("/")
    dongle_ip     = cfg["dongle_ip"]
    dongle_serial = int(cfg["dongle_serial"])

    # Deterministic device ID — hash of serial so we don't expose it
    device_id = hashlib.sha256(str(dongle_serial).encode()).hexdigest()[:16]

    # ── Step 1: validate license + fetch server-assigned sync interval ────────
    log.info("Validating license with server…")
    license_info = fetch_license(api_url, license_key)
    if license_info.get("valid") is False:
        log.error("License rejected by server: %s", license_info.get("reason", "unknown"))
        sys.exit(1)

    if "syncIntervalSeconds" in license_info:
        interval = license_info["syncIntervalSeconds"]
        save_sync_interval(interval)
        log.info("Sync interval from server: %ds", interval)
    else:
        interval = load_sync_interval()
        log.info("Using stored sync interval: %ds", interval)

    # ── Step 2: capture baseline inverter state for later revert ─────────────
    if not os.path.exists(_INITIAL_STATE_PATH):
        log.info("Capturing initial inverter control state…")
        baseline = read_inverter_control_state(dongle_ip, dongle_serial)
        if baseline:
            with open(_INITIAL_STATE_PATH, "w") as f:
                json.dump(baseline, f)
            log.info("Baseline saved: %s", baseline)
        else:
            log.warning("Could not read inverter baseline — revert will be unavailable")

    log.info("DeyLyte EMS starting — device_id=%s, interval=%ds, api=%s",
             device_id, interval, api_url)

    # Deterministic jitter — used after the first cycle to re-spread load.
    # On start/restart we send immediately so the user doesn't wait.
    jitter = startup_jitter(license_key, interval)
    log.info("First telemetry will be sent immediately; jitter of %ds applied after to re-spread load", jitter)

    # ── Step 3: main telemetry loop ───────────────────────────────────────────
    first_cycle = True
    while True:
        loop_start = time.monotonic()

        # 1. Read inverter
        telemetry = read_inverter(dongle_ip, dongle_serial)
        if telemetry is None:
            log.warning("Skipping this cycle — inverter unreachable")
            time.sleep(interval)
            continue

        log.info(
            "Telemetry — SOC: %.0f%%, PV: %.0fW, Grid: %.0fW, Load: %.0fW, Battery: %.0fW",
            telemetry["batterySOC"], telemetry["pvPowerW"],
            telemetry["gridPowerW"], telemetry["loadPowerW"],
            telemetry["batteryPowerW"],
        )

        # 2. POST to backend; receive commands / control signals
        response = post_telemetry(api_url, license_key, device_id, telemetry)

        # 3. Handle stop signal — license expired or deactivated
        if (response or {}).get("stop"):
            log.warning("Server signalled stop (license expired or deactivated). "
                        "Reverting inverter and halting telemetry.")
            revert_inverter(dongle_ip, dongle_serial)
            # Sleep indefinitely — operator must fix the license situation
            # and restart the add-on.
            while True:
                time.sleep(3600)

        # 4. Handle sync interval update from server
        if response and "syncIntervalSeconds" in response:
            new_interval = int(response["syncIntervalSeconds"])
            if new_interval != interval:
                log.info("Sync interval updated by server: %ds → %ds", interval, new_interval)
                interval = new_interval
                save_sync_interval(interval)

        # 5. Apply commands only if backend included them (live mode).
        #    No commands in response = planning mode → do nothing.
        commands = (response or {}).get("commands")
        if commands:
            apply_schedule(dongle_ip, dongle_serial, commands)
        else:
            log.info("No commands received — planning mode or no schedule yet")

        # Sleep for the remainder of the interval.
        # After the immediate first cycle, sleep the jitter to re-spread backend load;
        # subsequent cycles use the normal interval.
        elapsed = time.monotonic() - loop_start
        if first_cycle:
            first_cycle = False
            sleep_for = max(0, jitter - elapsed)
            log.info("First cycle done in %.1fs, jitter sleep %.0fs before resuming schedule", elapsed, sleep_for)
        else:
            sleep_for = max(0, interval - elapsed)
            log.info("Cycle done in %.1fs, sleeping %.0fs", elapsed, sleep_for)
        time.sleep(sleep_for)


if __name__ == "__main__":
    main()
