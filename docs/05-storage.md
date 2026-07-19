# 05 · Storage (NVMe, SSD, HDD)

## Concept

Storage inspection spans three layers:

```text
Physical device  →  Partition table  →  Filesystem / LVM / Btrfs subvolumes
   (NVMe/SATA)        (GPT/MBR)              (ext4, btrfs, xfs, vfat, …)
```

Health metrics (SMART / NVMe telemetry) need **root** and tools like `smartmontools` and `nvme-cli`.

---

## Commands

### `lsblk`

```bash
lsblk -e7 -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL
```

`-e7` excludes loop devices clutter from snaps/images.

**Live output:** [`outputs/storage/lsblk.txt`](../outputs/storage/lsblk.txt)

**Analysis:**

| Device | Role |
| :--- | :--- |
| `nvme0n1` | WD PC SN530 256 GB |
| `nvme0n1p1` | ESP (~4 GiB, vfat) → `/boot` |
| `nvme0n1p2` | Btrfs data volume → `/`, `/home`, logs, tmp |
| `zram0` | Compressed swap |

Serial numbers redacted in public sample.

### `findmnt`

Mount tree with options (subvol IDs, compression, noatime, etc.).

**Live output:** [`outputs/storage/findmnt.txt`](../outputs/storage/findmnt.txt)

### `df -hT`

Capacity by mountpoint and filesystem type.

**Live output:** [`outputs/storage/df_hT.txt`](../outputs/storage/df_hT.txt)

Root ~234 GiB Btrfs with ~43% used at capture — healthy free space for CoW snapshots.

### NVMe tooling

```bash
sudo nvme list
sudo nvme smart-log /dev/nvme0
```

**Live sample:** [`outputs/storage/nvme_list.txt`](../outputs/storage/nvme_list.txt) — `nvme-cli` was **not installed**; device node `/dev/nvme0` exists.

### SMART — `smartctl`

```bash
sudo smartctl -i /dev/nvme0n1    # identity
sudo smartctl -A /dev/nvme0n1    # attributes / health
# Do NOT auto-run self-tests in scripts without intent:
# sudo smartctl -t short /dev/nvme0n1
```

**Live samples:** permission denied without root — see [`outputs/storage/smartctl_i.txt`](../outputs/storage/smartctl_i.txt).

What to look for when elevated:

- Percentage used / media wear  
- Temperature  
- Unsafe shutdowns  
- Error logs / critical warning flags  

---

## Key takeaways

1. This host is a clean **NVMe + GPT + VFAT ESP + Btrfs** layout.
2. **Btrfs** shared subvolumes explain identical `df` numbers across `/`, `/home`, etc.
3. Install `nvme-cli` + run `smartctl` with sudo for production health monitoring.
4. Avoid unattended **SMART self-tests** unless you intend to stress the drive.

← [Memory](04-memory.md) · [Next: Motherboard →](06-motherboard-firmware.md)
