# 10 · Sensors, Temperatures & Fans

## Concept

Hardware monitoring chips expose temperatures, voltages, and fan PWM via:

- **`lm-sensors`** userspace (`sensors`)
- **hwmon** sysfs (`/sys/class/hwmon/`)
- **thermal zones** (`/sys/class/thermal/`)

`sensors-detect` can probe chips but is interactive and may write config — run manually when needed, not in unattended scripts.

---

## Commands

### `sensors`

**Live output:** [`outputs/sensors/sensors_out.txt`](../outputs/sensors/sensors_out.txt)

| Sensor | Reading (capture) | Notes |
| :--- | :--- | :--- |
| Package id 0 | ~50 °C | CPU package |
| Cores 0–3 | ~48–51 °C | Per-core |
| PCH | ~46 °C | Platform controller hub |
| iwlwifi | ~47 °C | Wi-Fi radio |
| NVMe composite | ~38 °C | Drive temperature |
| BAT0 voltage | ~11.6 V | Battery rail |

Critical thresholds for CPU are **100 °C** — idle temps in the 40–50 °C range are normal for a thin laptop.

### Thermal zones

```bash
cat /sys/class/thermal/thermal_zone*/type
cat /sys/class/thermal/thermal_zone*/temp   # millidegrees C
```

**Live output:** [`outputs/sensors/thermal_zones.txt`](../outputs/sensors/thermal_zones.txt)

### `sudo sensors-detect`

Interactive probe — **not run** in this lab’s automated capture. Use when `sensors` shows nothing after a fresh install.

### Fan control

`hp-isa-0000` showed `pwm1: N/A` — many business laptops hide fine-grained fan RPM from OS or expose it only via vendor EC interfaces.

---

## Key takeaways

1. Capture temps **at idle and under load** (e.g. `stress-ng`) for meaningful baselining.
2. NVMe and Wi-Fi sensors help diagnose thermal throttling of non-CPU components.
3. Missing fan RPM is common and not automatically a hardware fault.

← [USB](09-usb.md) · [Next: Power →](11-power-battery.md)
