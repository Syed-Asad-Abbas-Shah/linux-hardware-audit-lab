# 11 · Power, Battery & ACPI

## Concept

Laptop power data comes from:

| Source | Tool | Data |
| :--- | :--- | :--- |
| UPower | `upower` | Capacity, rate, time, cycles |
| ACPI | `acpi` | Quick status line |
| TLP | `tlp-stat -b` | Charge thresholds / health extras |
| sysfs | `/sys/class/power_supply/` | Raw kernel properties |

**Battery health** ≈ `energy-full / energy-full-design × 100`.

---

## Commands

### `upower`

**Live outputs:**

- [`outputs/power/upower_devices.txt`](../outputs/power/upower_devices.txt)
- [`outputs/power/upower_battery.txt`](../outputs/power/upower_battery.txt)

**Analysis (BAT0):**

| Metric | Value | Interpretation |
| :--- | :--- | :--- |
| State | Discharging | On battery at capture |
| Percentage | 78% | Current charge |
| Energy now | 31.8 Wh | |
| Energy full | 40.7 Wh | Current max charge |
| Design full | 53.0 Wh | Factory capacity |
| **Health** | **~76.8%** | Wear from aging |
| Cycles | 223 | Moderate use |
| Technology | Li-ion | |
| Voltage | ~11.8 V | vs 11.55 V design min |
| Rate | ~5.5 W | Light load drain |
| Time to empty | ~5.8 h | At that rate |
| AC online | no | Unplugged |

### `acpi -bi`

**Live output:** [`outputs/power/acpi.txt`](../outputs/power/acpi.txt) — package not installed on this host. Install with your package manager for a one-liner status.

### `sudo tlp-stat -b`

Optional if TLP is installed — charge thresholds (start/stop percentages) and platform quirks. Not present in this capture.

---

## Key takeaways

1. **~77% health / 223 cycles** is ordinary for a multi-year business laptop battery.
2. Track health over time; sudden drops may indicate cell failure.
3. For max lifespan, use charge thresholds (TLP/vendor tools) if you stay plugged in often.

← [Sensors](10-sensors.md) · [Next: PCI →](12-pci.md)
