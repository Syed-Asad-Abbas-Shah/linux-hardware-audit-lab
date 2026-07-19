# 14 · Graphical (GUI) Tools on CachyOS / KDE

## Concept

CLI tools are authoritative for scripts and remote servers. GUI tools help with **exploration, demos, and desktop support**.

These were **not** captured as screenshots in the automated lab run (interactive / GUI). Install and launch on a local session:

---

## Tools

| Tool | Launch | Purpose |
| :--- | :--- | :--- |
| **KInfoCenter** | `kinfocenter` | KDE hardware information center (CPU, GPU, devices, energy) |
| **HardInfo** | `hardinfo` | GTK system profiler / benchmarks / device tree |
| **Btop** | `btop` | Rich TUI for CPU, mem, disks, network, GPU (when available) |
| **GParted** | `gparted` | Graphical partition management (**destructive if misused**) |

### Package hints (Arch / CachyOS)

```bash
# examples — names may vary slightly
sudo pacman -S hardinfo btop gparted
# kinfocenter usually ships with Plasma
```

---

## How they map to this lab

| GUI | Closest CLI in this repo |
| :--- | :--- |
| KInfoCenter → Devices | `lspci`, `lsusb`, `inxi` |
| KInfoCenter → Energy | `upower`, `sensors` |
| HardInfo → Summary | `inxi -Fz`, `lscpu` |
| Btop | `btop` / `htop` / `intel_gpu_top` |
| GParted | `lsblk`, `findmnt`, `df` |

---

## Safety

- **GParted** can wipe disks — double-check device names.  
- Prefer **read-only** CLI captures for documentation and CI.  
- Do not include screenshots that show serials, hostnames, or open mail/chat windows.

← [Kernel](13-kernel-firmware.md) · [Back to README](../README.md)
