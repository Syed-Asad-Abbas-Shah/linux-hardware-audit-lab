# 13 · Kernel Drivers, Firmware & Modules

## Concept

Hardware only works when:

1. The **kernel module** (driver) loads  
2. Required **firmware blobs** are present  
3. Optional **userspace firmware updaters** (`fwupd`) can update device flash  

```text
Hardware → PCI/USB ID match → kernel module → firmware load → /dev nodes → userspace
```

---

## Commands

### `lsmod`

**Live output:** [`outputs/kernel/lsmod.txt`](../outputs/kernel/lsmod.txt)

Shows loaded modules and dependency counts. Useful modules on this host include graphics (`i915`), Wi-Fi (`iwlwifi`), audio SOF stack, NVMe, Bluetooth, etc.

```bash
lsmod | grep -E 'i915|iwlwifi|nvme|sof|btusb'
```

### Kernel log filter

```bash
sudo dmesg | grep -iE '(error|fail|warn|firmware)'
# or
journalctl -k -b | grep -iE '(error|fail|warn|firmware)'
```

**Live output:** [`outputs/kernel/dmesg_hw.txt`](../outputs/kernel/dmesg_hw.txt)

Raw `dmesg` was **not permitted** without privileges on this capture (common with kernel.dmesg_restrict). Use `sudo` or `journalctl -k`.

### `fwupdmgr get-devices`

**Live output:** [`outputs/kernel/fwupdmgr.txt`](../outputs/kernel/fwupdmgr.txt)

Enumerates updatable components, for example:

- CPU microcode version context  
- Internal SPI / BIOS region (**S70 Ver. 01.19.00**) — may show “firmware locked” depending on platform policy  
- Intel ME version  
- Synaptics **Prometheus** fingerprint reader  
- NVMe / UEFI devices when supported  
- Display panel identifiers (AUO)  

Update workflow:

```bash
fwupdmgr refresh
fwupdmgr get-updates
# sudo fwupdmgr update   # only when you intend to flash
```

---

## Key takeaways

1. Missing firmware often shows as soft-fail in **dmesg** (`Direct firmware load failed`).
2. **`fwupd`** is the professional path for vendor firmware on Linux.
3. Module blacklists / initramfs issues are common root causes when a device vanishes after updates.

← [PCI](12-pci.md) · [Next: GUI tools →](14-gui-tools.md)
