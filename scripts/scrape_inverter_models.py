#!/usr/bin/env python3
"""
scrape_inverter_models.py
─────────────────────────
Fetches Deye/SolarmanV5 inverter register definitions from the community
solarman-mqtt project (StephanJoubert/home_assistant_solarman) on GitHub,
maps them to the DeyLyte register-map format, and prints two outputs:

  1. A Dart snippet — paste into _inverterModels in deyelyte_server/lib/server.dart
  2. A summary table — shows what was auto-detected vs. needs manual input

Register keys we care about (all Modbus FC3 holding registers):
  batterySoc    — Battery state of charge (%)
  batteryPower  — Battery power W, signed int16 (+ charge / − discharge)
  gridPower     — Grid power W, signed int16 (+ import / − export)
  loadPower     — Site load W
  pv1Power      — PV string 1 W
  pv2Power      — PV string 2 W
  pv3Power      — PV string 3 W  (0 if absent)
  chargeCmd     — Write register: 1 = charge from grid  (manual — write reg)
  sellCmd       — Write register: 1 = sell to grid      (manual — write reg)

Control registers (chargeCmd / sellCmd) are write-only and are NOT in the
read-param definitions, so the script marks them as MANUAL. Known values for
verified models are kept in KNOWN_CONTROL_REGS below.

Usage:
  pip install requests pyyaml
  python scripts/scrape_inverter_models.py

  # Only Deye hybrid inverters (filter by filename prefix):
  python scripts/scrape_inverter_models.py --filter deye
"""

import argparse
import json
import sys
import time
from dataclasses import dataclass, field

import requests
import yaml

# ── GitHub source ─────────────────────────────────────────────────────────────

_GITHUB_API = "https://api.github.com"
_REPO       = "StephanJoubert/home_assistant_solarman"
_DEFS_PATH  = "custom_components/solarman/inverter_definitions"

# ── Manual register overrides ─────────────────────────────────────────────────
# Registers confirmed on real hardware that the community YAML doesn't define
# (e.g. pv3 on 2-string definitions, write-only control registers).
# Key = modelId substring (case-insensitive), value = dict of register overrides.

REGISTER_OVERRIDES: dict[str, dict[str, int]] = {
    "sg04lp3": {"pv3Power": 674},
}

# ── Known control registers (manual, not in read-param YAML) ─────────────────
# Add entries here as they are verified on real hardware.
# Key = model name substring (case-insensitive), value = (chargeCmd, sellCmd).

KNOWN_CONTROL_REGS: dict[str, tuple[int, int]] = {
    # Three-phase LP/HP family — all share the same protocol base.
    # chargeCmd=240/sellCmd=243 verified on SG04LP3 real hardware.
    "sg01hp3": (240, 243),   # same family — unverified
    "sg04lp3": (240, 243),   # ✓ verified
    "sg05lp3": (240, 243),   # same family — unverified
    "sg06lp3": (240, 243),   # same family — unverified
    "sg08lp3": (240, 243),   # same family — unverified
    "sg10lp3": (240, 243),   # same family — unverified
    "sg12lp3": (240, 243),   # same family — unverified
    # Single-phase LP family — unverified, same family assumption.
    "sg02lp1": (240, 243),
    "sg04lp1": (240, 243),
    "sg05lp1": (240, 243),
    "sg06lp1": (240, 243),
}

# ── Name heuristics for mapping items to our register keys ───────────────────

def _matches(name: str, *keywords) -> bool:
    n = name.lower()
    return all(kw in n for kw in keywords)

def _classify_item(item_name: str, rule: int) -> str | None:
    """
    Return our register key for a given item name + signedness rule, or None.
    rule 1/3 = unsigned, rule 2/4 = signed.
    """
    n = item_name.lower()
    signed = rule in (2, 4)

    if ("soc" in n or "state of charge" in n) and "battery" not in n.replace("battery soc", ""):
        return "batterySoc"
    if "battery" in n and "power" in n and signed:
        return "batteryPower"
    if "grid" in n and "power" in n and signed and "total" not in n.replace("total grid", ""):
        return "gridPower"
    if ("load" in n or "consumption" in n) and "power" in n and not signed:
        return "loadPower"
    # PV strings — order matters: check pv3 before pv2 before pv1
    if ("pv3" in n or "pv 3" in n or "string 3" in n) and "power" in n:
        return "pv3Power"
    if ("pv2" in n or "pv 2" in n or "string 2" in n) and "power" in n:
        return "pv2Power"
    if ("pv1" in n or "pv 1" in n or "string 1" in n) and "power" in n:
        return "pv1Power"
    # Fallback: bare "pv power" / "total pv" → pv1Power
    if ("pv" in n or "solar" in n) and "power" in n and "string" not in n:
        return "pv1Power"
    return None


# ── Data structures ───────────────────────────────────────────────────────────

@dataclass
class RegisterMap:
    modelId:     str
    displayName: str
    regs:        dict[str, int | None] = field(default_factory=dict)
    controlVerified: bool = False  # True if chargeCmd/sellCmd are from KNOWN_CONTROL_REGS

    REQUIRED_READ = ["batterySoc", "batteryPower", "gridPower", "loadPower",
                     "pv1Power", "pv2Power", "pv3Power"]
    CONTROL       = ["chargeCmd", "sellCmd"]

    def is_complete(self) -> bool:
        return all(self.regs.get(k) is not None for k in self.REQUIRED_READ)

    def missing_keys(self) -> list[str]:
        return [k for k in self.REQUIRED_READ + self.CONTROL if not self.regs.get(k)]


# ── GitHub helpers ────────────────────────────────────────────────────────────

def _gh_get(path: str, session: requests.Session) -> dict | list:
    url = f"{_GITHUB_API}/repos/{_REPO}/contents/{path}"
    resp = session.get(url, timeout=15)
    if resp.status_code == 403:
        print("GitHub rate-limit hit — add a GITHUB_TOKEN or slow down.", file=sys.stderr)
        sys.exit(1)
    resp.raise_for_status()
    return resp.json()


def _raw_url(file_entry: dict) -> str:
    return file_entry["download_url"]


# ── Parser ────────────────────────────────────────────────────────────────────

def _model_id(name: str) -> str:
    """'deye_sg04lp3' or 'SG04LP3-EU' → 'deye_sg04lp3_eu'"""
    slug = name.lower().replace("-", "_").replace(" ", "_")
    return slug if slug.startswith("deye_") else f"deye_{slug}"


def parse_definition(raw_yaml: str, filename: str) -> RegisterMap | None:
    try:
        doc = yaml.safe_load(raw_yaml)
    except yaml.YAMLError as e:
        print(f"  YAML parse error in {filename}: {e}", file=sys.stderr)
        return None

    if not isinstance(doc, dict):
        return None

    # Some files have a top-level 'name', others don't — fall back to filename.
    raw_name = doc.get("name") or filename.replace(".yaml", "")
    # Humanise: 'deye_sg04lp3' → 'SG04LP3'
    model_name = raw_name.replace("deye_", "").replace("_", " ").upper()
    rm = RegisterMap(
        modelId=_model_id(raw_name),
        displayName=f"Deye {model_name}",
    )

    # Walk all parameters → groups → items
    for group in doc.get("parameters", doc.get("params", [])):
        for item in group.get("items", []):
            name  = item.get("name", "")
            rule  = item.get("rule", 1)
            regs_list = item.get("registers", [])
            if not regs_list:
                continue
            reg = int(regs_list[0])  # take first register address
            key = _classify_item(name, rule)
            if key and rm.regs.get(key) is None:
                rm.regs[key] = reg

    # Fill missing pv3 with 0 if only pv1+pv2 detected (common for 2-string models)
    if rm.regs.get("pv1Power") and rm.regs.get("pv2Power") and not rm.regs.get("pv3Power"):
        rm.regs["pv3Power"] = 0

    # Apply manual register overrides (hardware-confirmed values)
    for key_fragment, overrides in REGISTER_OVERRIDES.items():
        if key_fragment in raw_name.lower():
            rm.regs.update(overrides)

    # Apply known control registers
    for key_fragment, (charge, sell) in KNOWN_CONTROL_REGS.items():
        if key_fragment in raw_name.lower():
            rm.regs["chargeCmd"] = charge
            rm.regs["sellCmd"]   = sell
            rm.controlVerified   = key_fragment == "sg04lp3"
            break

    return rm


# ── Output formatters ─────────────────────────────────────────────────────────

def _reg_map_json(rm: RegisterMap) -> str:
    keys = ["batterySoc", "batteryPower", "gridPower", "loadPower",
            "pv1Power", "pv2Power", "pv3Power", "chargeCmd", "sellCmd"]
    parts = [f'"{k}":{rm.regs.get(k, "null")}' for k in keys]
    return "{" + ",".join(parts) + "}"


def print_dart_snippet(models: list[RegisterMap]) -> None:
    print("\n" + "─" * 72)
    print("DART SNIPPET — paste into _inverterModels in server.dart")
    print("─" * 72)
    print("const _inverterModels = [")
    for rm in models:
        verified = "✓ verified" if rm.controlVerified else "⚠ control regs unverified"
        print(f"  // {rm.displayName} ({verified})")
        print(f"  (")
        print(f"    modelId: '{rm.modelId}',")
        print(f"    displayName: '{rm.displayName}',")
        reg_json = _reg_map_json(rm)
        # Escape the JSON string for Dart
        escaped = reg_json.replace("'", "\\'")
        print(f"    registerMapJson: '{escaped}',")
        print(f"  ),")
    print("];")


def print_summary(models: list[RegisterMap], skipped: list[str]) -> None:
    print("\n" + "─" * 72)
    print(f"SUMMARY: {len(models)} models parsed, {len(skipped)} skipped")
    print("─" * 72)
    all_keys = ["batterySoc", "batteryPower", "gridPower", "loadPower",
                "pv1Power", "pv2Power", "pv3Power", "chargeCmd", "sellCmd"]
    header = f"{'Model':<30} " + " ".join(f"{k[:8]:>8}" for k in all_keys)
    print(header)
    print("─" * len(header))
    for rm in models:
        row = f"{rm.displayName:<30} "
        for k in all_keys:
            v = rm.regs.get(k)
            if v is None:
                row += f"{'MISSING':>8} "
            elif v == 0:
                row += f"{'(0)':>8} "
            else:
                row += f"{v:>8} "
        print(row)
    if skipped:
        print(f"\nSkipped (non-Deye or no relevant params): {', '.join(skipped)}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    parser = argparse.ArgumentParser(description="Scrape Deye inverter register maps")
    parser.add_argument("--filter", default="deye",
                        help="Filename prefix filter (default: deye). Use '' for all.")
    parser.add_argument("--no-filter", action="store_true",
                        help="Disable filename filtering (fetch all models)")
    args = parser.parse_args()

    prefix = "" if args.no_filter else args.filter.lower()

    s = requests.Session()
    s.headers.update({"Accept": "application/vnd.github+json",
                       "User-Agent": "deylyte-scraper/1.0"})

    print(f"Fetching definition file list from GitHub ({_REPO})…")
    entries = _gh_get(_DEFS_PATH, s)
    if not isinstance(entries, list):
        print("Unexpected GitHub API response.", file=sys.stderr)
        sys.exit(1)

    yaml_files = [e for e in entries
                  if e["name"].endswith(".yaml")
                  and (not prefix or e["name"].lower().startswith(prefix))]

    print(f"Found {len(yaml_files)} YAML files matching filter '{prefix or '*'}'")

    models: list[RegisterMap] = []
    skipped: list[str] = []

    for entry in yaml_files:
        name = entry["name"]
        print(f"  Parsing {name}…")
        raw = s.get(_raw_url(entry), timeout=15).text
        rm = parse_definition(raw, name)
        if rm is None or not rm.regs:
            skipped.append(name)
            continue
        # Only include if we got at least the battery+pv registers
        if rm.regs.get("batterySoc") and rm.regs.get("pv1Power"):
            models.append(rm)
        else:
            skipped.append(name)
        time.sleep(0.1)  # be kind to GitHub

    models.sort(key=lambda m: m.displayName)

    print_summary(models, skipped)
    print_dart_snippet(models)

    # Also write a JSON file for easy inspection
    out_path = "scripts/inverter_models_scraped.json"
    with open(out_path, "w") as f:
        json.dump(
            [{"modelId": m.modelId,
              "displayName": m.displayName,
              "registers": m.regs,
              "complete": m.is_complete(),
              "missing": m.missing_keys()}
             for m in models],
            f, indent=2,
        )
    print(f"\nFull register data written to {out_path}")


if __name__ == "__main__":
    main()
