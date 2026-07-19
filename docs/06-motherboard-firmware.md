# 06 · Motherboard, BIOS / UEFI & Chassis

## Concept

Firmware and board identity come from **SMBIOS/DMI** tables and the **UEFI** runtime:

| Source | Tools | Data |
| :--- | :--- | :--- |
| SMBIOS | `dmidecode` | Board model, BIOS vendor/version, UUID, chassis |
| UEFI sysfs | `/sys/firmware/efi` | Confirms UEFI boot path |
| Bootloader | `bootctl`, ESP files | systemd-boot/GRUB, Secure Boot |

Serial numbers and UUIDs are sensitive — redact before publishing.

---

## Commands

### `sudo dmidecode -t baseboard|bios|system|chassis`

**Elevated.** Public capture without sudo failed (permission denied on DMI tables):

- [`outputs/motherboard/dmidecode_baseboard.txt`](../outputs/motherboard/dmidecode_baseboard.txt)
- [`outputs/motherboard/dmidecode_bios.txt`](../outputs/motherboard/dmidecode_bios.txt)
- [`outputs/motherboard/dmidecode_system.txt`](../outputs/motherboard/dmidecode_system.txt)
- [`outputs/motherboard/dmidecode_chassis.txt`](../outputs/motherboard/dmidecode_chassis.txt)

**Cross-check from unprivileged tools** (`inxi`, `hostnamectl`, `fwupdmgr`):

| Field | Value |
| :--- | :--- |
| System | HP EliteBook 840 G7 Notebook PC |
| Board model | HP 8723 |
| KBC | Version 06.4C.00 |
| BIOS | HP S70 Ver. 01.19.00 · 2024-11-24 |
| Chassis | Laptop |

### UEFI check

```bash
ls /sys/firmware/efi
```

**Live output:** [`outputs/motherboard/efi_check.txt`](../outputs/motherboard/efi_check.txt)

If this directory exists, the system booted in **UEFI mode** (not legacy CSM-only).

### `bootctl status`

Shows EFI System Partition, boot entries, Secure Boot state (when readable).

**Live output:** [`outputs/motherboard/bootctl.txt`](../outputs/motherboard/bootctl.txt)

Some ESP paths required elevated access on this host; firmware still confirmed UEFI via sysfs and `hostnamectl`.

### Firmware inventory via fwupd

```bash
fwupdmgr get-devices
```

See [13 · Kernel & firmware](13-kernel-firmware.md) for the full device tree (BIOS region, ME, fingerprint reader, NVMe firmware, etc.).

---

## Key takeaways

1. **UEFI + HP S70 01.19.00** — relatively recent firmware for a G7 EliteBook.
2. Prefer **`hostnamectl` + `fwupdmgr`** when you cannot use sudo for DMI.
3. Never publish raw **system UUID / board serial** from `dmidecode -t system`.

← [Storage](05-storage.md) · [Next: Network →](07-network-bluetooth.md)
