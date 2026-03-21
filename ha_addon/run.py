#!/usr/bin/env python3
"""
DeyLyte EMS Add-on
------------------
1. Reads inverter state via SolarmanV5 every TELEMETRY_INTERVAL seconds.
2. POSTs telemetry to the DeyLyte backend.
3. Receives schedule + planning mode flag in the response.
4. Applies inverter commands only when NOT in planning mode.

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
            "telemetry_interval_seconds": int(os.environ.get("TELEMETRY_INTERVAL", "300")),
        }
    with open(options_path) as f:
        return json.load(f)


def validate_config(cfg: dict) -> bool:
    missing = [k for k in ("license_key", "dongle_ip", "dongle_serial") if not cfg.get(k)]
    if missing:
        log.error("Missing required config: %s", ", ".join(missing))
        return False
    return True


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

# SolarmanV5 register addresses for Deye Sun series
# Adjust these if your inverter firmware uses different addresses.
_REG_BATTERY_SOC    = 168   # % (0-100)
_REG_PV_POWER       = 186   # W (total PV input)
_REG_GRID_POWER     = 625   # W (positive = import from grid, negative = export to grid)
_REG_LOAD_POWER     = 178   # W
_REG_BATTERY_POWER  = 190   # W (positive = charging, negative = discharging)
_REG_CHARGE_MODE    = 168   # used as a proxy; real charge cmd reg below
_REG_CHARGE_CMD     = 240   # write: 1 = charge from grid, 0 = disable
_REG_SELL_CMD       = 243   # write: 1 = sell to grid, 0 = disable


def read_inverter(dongle_ip: str, dongle_serial: int) -> dict | None:
    try:
        solarman = PySolarmanV5(dongle_ip, dongle_serial, port=8899, mb_slave_id=1, verbose=False)
        battery_soc   = solarman.read_input_register_formatted(_REG_BATTERY_SOC, 1)
        pv_power      = solarman.read_input_register_formatted(_REG_PV_POWER, 1)
        grid_power    = solarman.read_input_register_formatted(_REG_GRID_POWER, 1)
        load_power    = solarman.read_input_register_formatted(_REG_LOAD_POWER, 1)
        battery_power = solarman.read_input_register_formatted(_REG_BATTERY_POWER, 1)
        solarman.disconnect()
        return {
            "batterySOC":    float(battery_soc),
            "pvPowerW":      float(pv_power),
            "gridPowerW":    float(grid_power),
            "loadPowerW":    float(load_power),
            "batteryPowerW": float(battery_power),
        }
    except Exception as exc:
        log.warning("Failed to read inverter: %s", exc)
        return None


def apply_schedule(dongle_ip: str, dongle_serial: int, commands: dict) -> None:
    """Write charge/sell commands to the inverter."""
    try:
        solarman = PySolarmanV5(dongle_ip, dongle_serial, port=8899, mb_slave_id=1, verbose=False)
        if "chargeFromGrid" in commands:
            solarman.write_holding_register(_REG_CHARGE_CMD, 1 if commands["chargeFromGrid"] else 0)
        if "sellToGrid" in commands:
            solarman.write_holding_register(_REG_SELL_CMD, 1 if commands["sellToGrid"] else 0)
        solarman.disconnect()
        log.info("Applied commands: %s", commands)
    except Exception as exc:
        log.warning("Failed to apply schedule: %s", exc)


# ── Backend ───────────────────────────────────────────────────────────────────

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
        return resp.json()
    except Exception as exc:
        log.warning("Failed to POST telemetry: %s", exc)
        return None


# ── Main loop ─────────────────────────────────────────────────────────────────

def main() -> None:
    cfg = load_config()
    if not validate_config(cfg):
        sys.exit(1)

    license_key = cfg["license_key"]
    api_url     = cfg["api_url"].rstrip("/")
    dongle_ip   = cfg["dongle_ip"]
    dongle_serial = int(cfg["dongle_serial"])
    interval    = int(cfg["telemetry_interval_seconds"])

    # Deterministic device ID — hash of serial so we don't expose it
    device_id = hashlib.sha256(str(dongle_serial).encode()).hexdigest()[:16]

    log.info("DeyLyte EMS starting — device_id=%s, interval=%ds, api=%s",
             device_id, interval, api_url)

    # Spread load: sleep a deterministic offset before the first poll
    jitter = startup_jitter(license_key, interval)
    log.info("Startup jitter: %ds (spreads load across %ds window)", jitter, interval)
    time.sleep(jitter)

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

        # 2. POST to backend; receive commands if user is in live mode
        response = post_telemetry(api_url, license_key, device_id, telemetry)

        # 3. Apply commands only if backend included them (live mode).
        #    No commands in response = planning mode → do nothing.
        commands = (response or {}).get("commands")
        if commands:
            apply_schedule(dongle_ip, dongle_serial, commands)
        else:
            log.info("No commands received — planning mode or no schedule yet")

        # Sleep for the remainder of the interval
        elapsed = time.monotonic() - loop_start
        sleep_for = max(0, interval - elapsed)
        log.info("Cycle done in %.1fs, sleeping %.0fs", elapsed, sleep_for)
        time.sleep(sleep_for)


if __name__ == "__main__":
    main()
