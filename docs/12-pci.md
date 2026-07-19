# 12 · PCI & Bus Devices

## Concept

The **PCI Express** fabric connects CPU root complex to GPU, NVMe, network, USB host controllers, and Thunderbolt bridges.

```bash
lspci           # flat list
lspci -tv       # tree
sudo lspci -vvv # verbose: link speed, width, kernel driver, BARs
```

Bus addresses look like `BB:DD.F` (bus:device.function).

---

## Commands

### `lspci`

**Live output:** [`outputs/pci/lspci.txt`](../outputs/pci/lspci.txt)

**Major devices on this machine:**

| Address | Function |
| :--- | :--- |
| `00:00.0` | Host bridge / DRAM controller (Comet Lake-U) |
| `00:02.0` | UHD Graphics (iGPU) |
| `00:14.0` | USB 3.2 xHCI |
| `00:14.3` | CNVi Wi-Fi |
| `00:1f.3` | HD Audio |
| `01:00.0`–`37:00.0` | Thunderbolt 3 Titan Ridge bridge chain + NHI + USB |
| `6b:00.0` | WD/SanDisk NVMe SSD |

### `lspci -tv`

**Live output:** [`outputs/pci/lspci_tv.txt`](../outputs/pci/lspci_tv.txt)

Tree form clarifies that NVMe hangs off a root port and Thunderbolt forms a multi-bridge cascade (normal for Titan Ridge).

### `lspci -vvv`

**Live output (partial):** [`outputs/pci/lspci_vvv.txt`](../outputs/pci/lspci_vvv.txt)

Look for:

- `LnkSta:` negotiated **speed** (e.g. 8 GT/s = PCIe 3.0) and **width** (x1/x4/x16)
- `Kernel driver in use:`
- Power management (ASPMs)

Root is often needed for full config-space detail.

---

## Key takeaways

1. Thunderbolt **looks noisy** in `lspci` — multiple bridges even with nothing docked.
2. NVMe at `6b:00.0` is the primary storage controller.
3. Use verbose mode when diagnosing **link degradation** (device stuck at x1 or Gen1).

← [Power](11-power-battery.md) · [Next: Kernel →](13-kernel-firmware.md)
