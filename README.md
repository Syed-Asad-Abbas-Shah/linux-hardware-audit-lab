# Asad Linux Hardware Audit Lab

**Professional Linux hardware inspection, live command captures, and systems-engineering analysis**

[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20CachyOS%20%7C%20Arch-blue)](#)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Hardware](https://img.shields.io/badge/reference%20machine-HP%20EliteBook%20840%20G7-informational)](#reference-machine)
[![Kernel](https://img.shields.io/badge/kernel-7.1.3--2--cachyos-orange)](#)

> Authored by **Syed Asad Abbas Shah**  
> A public, developer-oriented laboratory for auditing Linux hardware using real terminal commands, real outputs, and clear engineering explanations.

---

## Why this repository exists

Most “hardware command lists” stop at a one-line description. This lab goes further:

| Layer | What you get |
| :--- | :--- |
| **Commands** | Exact, copy-paste ready inspection commands |
| **Live output** | Captured on a real machine (privacy-redacted) |
| **Analysis** | What the numbers mean for health, drivers, and performance |
| **Concepts** | Kernel interfaces, buses, firmware, and user-space tooling |
| **Reproducibility** | A collector script so anyone can re-run the full audit |

This is intended for developers, sysadmins, support engineers, and Linux learners who want a **professional reference**, not a bare cheatsheet.

---

## Reference machine

Captured on **2026-07-19** (CachyOS / Arch family).

| Component | Specification |
| :--- | :--- |
| **System** | HP EliteBook 840 G7 Notebook PC |
| **CPU** | Intel Core i7-10610U · 4 cores / 8 threads · 400 MHz–4.90 GHz |
| **GPU** | Intel Comet Lake-U GT2 (UHD Graphics) · driver `i915` · Mesa 26.1.4 |
| **Display** | 1920×1080 @ 60 Hz · Wayland (KWin) · OpenGL 4.6 · Vulkan 1.4 |
| **Memory** | ~8 GiB (7.54 GiB available) · zram swap 7.53 GiB |
| **Storage** | WD PC SN530 256 GB NVMe · Btrfs root · VFAT ESP |
| **Network** | Intel CNVi Wi-Fi (`iwlwifi`) · Intel AX201 Bluetooth 5.2 |
| **Audio** | Intel 400 Series HD Audio · SOF driver · PipeWire 1.6.8 |
| **I/O** | USB 3.2 xHCI · Thunderbolt 3 (Titan Ridge JHL7540) · Synaptics fingerprint |
| **Firmware** | UEFI · HP S70 Ver. 01.19.00 (2024-11-24) |
| **OS** | CachyOS · Kernel `7.1.3-2-cachyos` · KDE Plasma 6.7.3 |
| **Battery** | Li-ion · ~76.8% design capacity remaining · 223 charge cycles |

Sensitive identifiers (serials, MACs, IPs, machine IDs) are redacted in public outputs.

---

## Quick start

### Browse the lab

| Section | Topic |
| :--- | :--- |
| [01 · System summary](docs/01-system-summary.md) | Full-stack overview (`inxi`, `fastfetch`, `hostnamectl`) |
| [02 · CPU](docs/02-cpu.md) | Topology, caches, governors, virtualization |
| [03 · GPU & display](docs/03-gpu-display.md) | OpenGL, Vulkan, OpenCL, monitors |
| [04 · Memory](docs/04-memory.md) | RAM, swap, `/proc/meminfo`, physical modules |
| [05 · Storage](docs/05-storage.md) | NVMe, partitions, SMART, filesystems |
| [06 · Motherboard & firmware](docs/06-motherboard-firmware.md) | SMBIOS/DMI, UEFI, bootloader |
| [07 · Network & Bluetooth](docs/07-network-bluetooth.md) | Wi-Fi, RF kill, Bluetooth controller |
| [08 · Audio](docs/08-audio.md) | ALSA, PipeWire, SOF HDA |
| [09 · USB](docs/09-usb.md) | Device tree, speeds, descriptors |
| [10 · Sensors](docs/10-sensors.md) | Temperatures, thermal zones, fans |
| [11 · Power & battery](docs/11-power-battery.md) | Capacity, cycles, AC adapter |
| [12 · PCI bus](docs/12-pci.md) | Chipset map, Thunderbolt, PCIe |
| [13 · Kernel & firmware](docs/13-kernel-firmware.md) | Modules, dmesg, `fwupd` |
| [14 · GUI tools](docs/14-gui-tools.md) | KInfoCenter, HardInfo, btop, GParted |

### Re-run the audit on your machine

```bash
git clone https://github.com/Syed-Asad-Abbas-Shah/Asad-Linux-Hardware-Audit-Lab.git
cd Asad-Linux-Hardware-Audit-Lab
chmod +x scripts/collect-hardware-info.sh
./scripts/collect-hardware-info.sh
# Optional elevated capture (DMI, SMART, full lshw, dmesg):
sudo ./scripts/collect-hardware-info.sh --with-sudo
```

Outputs land in `outputs/` (local run). The committed samples under `outputs/` are the **reference capture** from the HP EliteBook 840 G7.

---

## Repository layout

```text
Asad-Linux-Hardware-Audit-Lab/
├── README.md                 # You are here
├── LICENSE                   # MIT
├── docs/                     # Concepts + analysis per subsystem
├── outputs/                  # Privacy-redacted live command captures
│   ├── system/
│   ├── cpu/
│   ├── gpu/
│   └── ...
└── scripts/
    └── collect-hardware-info.sh
```

---

## Command coverage map

Commands are organized by subsystem. **Elevated** means root is required for full data.

### System overview

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `inxi -Fz` | user | Portable multi-subsystem hardware summary (filters MACs) |
| `inxi -Fxz` | user | Extended summary including repos / extra detail |
| `fastfetch` | user | Fast neofetch-style snapshot for desktop context |
| `hostnamectl` | user | Machine identity, chassis, firmware metadata |
| `uname -a` | user | Kernel release string and architecture |
| `sudo lshw -short` | elevated | Hierarchical hardware inventory |
| `sudo lshw -html > report.html` | elevated | Browser-readable full inventory |

### CPU

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `lscpu` | user | Topology, caches, flags, side-channel mitigations |
| `cat /proc/cpuinfo` | user | Per-logical-CPU raw kernel view |
| `lscpu --extended` | user | Core/socket/cache sharing table |
| `cpupower frequency-info` | user | P-state driver, governor, boost |
| `lstopo` | user | NUMA / cache / PCIe locality map (`hwloc`) |

### GPU & display

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `lspci -k \| grep -A 3 -E "(VGA\|3D)"` | user | GPU PCI ID + bound kernel driver |
| `glxinfo \| grep ...` | user | Active OpenGL stack / renderer |
| `vulkaninfo --summary` | user | Vulkan devices and instance layers |
| `clinfo` | user | OpenCL compute devices |
| `xrandr` / `kscreen-doctor -l` | user | Modes, connectors, DE display config |
| `nvidia-smi` / `nvtop` / `radeontop` / `intel_gpu_top` | user | Vendor-specific monitoring (if present) |

### Memory

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `free -h` | user | Total / used / available / swap |
| `cat /proc/meminfo` | user | Kernel memory counters |
| `lsmem` | user | Online memory ranges and block size |
| `vmstat -s` | user | VM event counters |
| `sudo dmidecode --type memory` | elevated | DIMM slots, speed, part numbers |

### Storage

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `lsblk -e7 -o ...` | user | Block devices, models, mounts |
| `sudo nvme list` | elevated | NVMe namespaces (`nvme-cli`) |
| `sudo smartctl -i/-A DEVICE` | elevated | Identity + SMART attributes |
| `findmnt` | user | Mount tree and options |
| `df -hT` | user | Capacity by filesystem type |

### Firmware, buses, sensors, power

| Command | Privilege | Concept |
| :--- | :--- | :--- |
| `sudo dmidecode -t baseboard/bios/system/chassis` | elevated | SMBIOS tables |
| `ls /sys/firmware/efi` | user | UEFI vs legacy boot signal |
| `bootctl status` | mixed | systemd-boot / Secure Boot state |
| `lspci` / `lspci -tv` / `sudo lspci -vvv` | mixed | PCI topology and link training |
| `lsusb` / `lsusb -t` | user | USB devices and speeds |
| `sensors` | user | lm-sensors temperatures / fans |
| `upower -i ...` | user | Battery chemistry, cycles, rate |
| `lsmod` / `fwupdmgr get-devices` | user | Loaded modules / updatable firmware |

---

## Engineering findings (reference capture)

### Health snapshot

| Check | Result | Notes |
| :--- | :--- | :--- |
| CPU thermal | ~48–51 °C package idle | Well below 100 °C critical |
| NVMe thermal | ~38 °C | Comfortable margin under 80 °C high |
| Battery health | **76.8%** of design | 223 cycles — normal aging for a few years of use |
| Storage free space | ~57% free on root | Healthy headroom for Btrfs |
| Wi-Fi / Bluetooth | Up, unblocked | `iwlwifi` + AX201 active |
| Graphics stack | Mesa iris + Vulkan Intel | Full open-source Intel stack |
| Firmware | UEFI, BIOS 01.19.00 | Recent HP firmware date (2024-11) |

### Architecture notes

1. **Comet Lake-U platform** — single package with integrated UHD Graphics; no discrete GPU, so `nvidia-smi` is N/A.
2. **Thunderbolt 3 Titan Ridge** appears as a multi-hop PCI bridge chain — normal for Alpine Ridge / Titan Ridge designs.
3. **SOF audio path** (`sof-audio-pci-intel-cnl`) is the modern Intel DSP pipeline; ALSA card is `sof-hda-dsp`.
4. **zram swap** provides compressed in-RAM swap — good for 8 GiB laptops under memory pressure.
5. **Btrfs subvolume layout** shares one NVMe partition for `/`, `/home`, logs, and tmp with separate VFAT ESP.

### Privilege gaps in the public capture

These need `sudo` (or missing packages) for complete data on this host:

| Area | Status in public sample |
| :--- | :--- |
| `dmidecode` (DIMMs / board serials) | Permission denied without root |
| `smartctl` / `nvme` SMART | Permission denied / `nvme-cli` not installed |
| `dmesg` ring buffer | Operation not permitted (kernel lockdown / privileges) |
| `acpi` / `tlp-stat` | Not installed |
| `lshw` | Not installed |
| Interactive tools (`nvtop`, `btop`, `sensors-detect`) | Intentionally not captured as live TUI sessions |

The documentation still explains **what those commands return** and how to interpret them when run with privileges.

---

## Privacy & safety policy

Public artifacts are scrubbed for:

- MAC addresses and Bluetooth controller addresses  
- Local IPv4 addresses  
- Serial numbers and part UUIDs  
- Machine ID / boot ID / hostnames  

**Not run** in the automated collector by default:

- Destructive or long-running SMART self-tests (`smartctl -t short`)  
- Interactive `sensors-detect` (can rewrite configs)  
- GUI apps (`kinfocenter`, `gparted`, …)

---

## Contributing

Improvements welcome:

1. Additional distro notes (Fedora, Ubuntu, NixOS paths).
2. Better redaction rules for enterprise identifiers.
3. Optional JSON export for inventory automation.
4. Screenshots of GUI tools under `docs/assets/` (no private data).

Open a PR against this repository with a clear description of the subsystem you improved.

---

## License

MIT © Syed Asad Abbas Shah — see [LICENSE](LICENSE).

---

## Author

**Syed Asad Abbas Shah**  
GitHub: [Syed-Asad-Abbas-Shah](https://github.com/Syed-Asad-Abbas-Shah)

*Built as a professional public hardware audit lab — commands, outputs, analysis, and concepts in one place.*
