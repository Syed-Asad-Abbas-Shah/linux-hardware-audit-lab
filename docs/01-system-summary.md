# 01 · System Summary & General Overview

## Concept

A **system summary** answers: *What machine is this, what OS/kernel is running, and what are the major components?*  
Linux exposes this through several layers:

| Layer | Examples | Role |
| :--- | :--- | :--- |
| Kernel identity | `uname`, `/proc/version` | Exact kernel build |
| systemd machine metadata | `hostnamectl` | Chassis, firmware, OS pretty name |
| Aggregators | `inxi`, `fastfetch` | Human-readable multi-subsystem report |
| Inventory tools | `lshw`, HardInfo | Deep hierarchical hardware trees |

Start here before drilling into CPU, GPU, or storage.

---

## Commands

### `inxi -Fz`

**What it does:** Collects CPU, GPU, memory, drives, network, battery, sensors, and desktop info into one report. `-F` is full; `-z` filters sensitive fields (MACs, serials when possible).

**When to use:** First command on an unfamiliar Linux box.

**Live output (reference machine):** see [`outputs/system/inxi_Fz.txt`](../outputs/system/inxi_Fz.txt)

**Analysis (EliteBook 840 G7):**

- Distro **CachyOS**, desktop **KDE Plasma 6.7.3**, kernel **7.1.3-2-cachyos**
- Laptop form factor with **Intel i7-10610U** and **Intel UHD Graphics**
- Single **WD SN530 256 GB** NVMe, **Btrfs** root, **zram** swap
- Battery condition **~76.8%** of design capacity

### `inxi -Fxz`

Same family as above with extra detail (`-x` extra). Useful when comparing package/repo context across machines.

**Live output:** [`outputs/system/inxi_Fxz.txt`](../outputs/system/inxi_Fxz.txt)

### `fastfetch`

Modern, fast “neofetch-style” snapshot: OS, host, kernel, DE/WM, CPU/GPU clocks, memory, disk, battery.

**Live output:** [`outputs/system/fastfetch.txt`](../outputs/system/fastfetch.txt)

**Analysis:** Confirms Wayland session under KWin, 1920×1080 built-in panel, ~2 GiB RAM used at idle capture, packages from pacman/flatpak/snap.

### `hostnamectl`

systemd’s machine description: chassis type, hardware vendor/model, firmware version/date, architecture.

**Live output:** [`outputs/system/hostnamectl.txt`](../outputs/system/hostnamectl.txt)

**Analysis:**

| Field | Value |
| :--- | :--- |
| Vendor / Model | HP · EliteBook 840 G7 |
| Firmware | S70 Ver. 01.19.00 · 2024-11-24 |
| Chassis | laptop |
| Arch | x86-64 |

### `uname -a`

Minimal kernel string: nodename, release, version, machine.

**Live output:** [`outputs/system/uname_a.txt`](../outputs/system/uname_a.txt)

```text
Linux <host> 7.1.3-2-cachyos #1 SMP PREEMPT_DYNAMIC ... x86_64 GNU/Linux
```

`PREEMPT_DYNAMIC` indicates a desktop/latency-friendly CachyOS kernel configuration.

### `sudo lshw -short` / HTML report

**Elevated.** `lshw` walks sysfs/DMI/PCI for a full tree. HTML export is ideal for support tickets.

```bash
sudo lshw -short
sudo lshw -html > ~/Documents/hardware_report.html
```

Not captured in the public sample (`lshw` was not installed; requires root for complete data).

---

## Key takeaways

1. Use **`inxi -Fz`** for a single portable overview.
2. Use **`hostnamectl`** when you need firmware version/date without guessing BIOS menus.
3. Use **`uname -a`** in bug reports — maintainers need the exact kernel release.
4. Prefer **filtered** outputs (`-z`, redaction) before publishing hardware dumps.

← [README](../README.md) · [Next: CPU →](02-cpu.md)
