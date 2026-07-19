# 07 · Network, Wi-Fi & Bluetooth

## Concept

Wireless on modern Intel laptops often uses **CNVi** (Connectivity Integration): Wi-Fi and Bluetooth share silicon/firmware with separate kernel drivers.

| Function | Typical driver | Userspace |
| :--- | :--- | :--- |
| Wi-Fi | `iwlwifi` | NetworkManager, iwd, wpa_supplicant |
| Bluetooth | `btusb` + BlueZ | `bluetoothctl` |
| RF kill | rfkill subsystem | `rfkill list` |

---

## Commands

### PCI network device

```bash
lspci -k | grep -A 3 -i network
```

**Live output:** [`outputs/network/lspci_network.txt`](../outputs/network/lspci_network.txt)

**Analysis:** Intel 400 Series On-Package CNVi Wi-Fi, driver **`iwlwifi`**.

### Interfaces — `ip link` / `ip addr`

**Live outputs:**

- [`outputs/network/ip_link.txt`](../outputs/network/ip_link.txt)
- [`outputs/network/ip_addr.txt`](../outputs/network/ip_addr.txt)

| IF | State | Notes |
| :--- | :--- | :--- |
| `lo` | UP | Loopback |
| `wlan0` | UP | Active Wi-Fi (addresses redacted) |

No Ethernet `eth0`/`enp*` was up at capture (dock/USB-NIC would appear when attached).

### Wi-Fi management

```bash
iwctl device list
nmcli device
```

**Live outputs:** [`outputs/network/iwctl.txt`](../outputs/network/iwctl.txt), [`outputs/network/nmcli_wifi.txt`](../outputs/network/nmcli_wifi.txt)

### `ethtool`

Useful for **wired** NICs (link speed, duplex). On pure Wi-Fi hosts it may error for `wlan0` — expected.

**Live output:** [`outputs/network/ethtool_wlan0.txt`](../outputs/network/ethtool_wlan0.txt)

### Bluetooth — `bluetoothctl show`

**Live output:** [`outputs/network/bluetoothctl.txt`](../outputs/network/bluetoothctl.txt)

Controller powered, dual role (central/peripheral), classic + LE profiles (A2DP, HFP, GATT, …). Hardware is **Intel AX201** (USB ID `8087:0026` in lsusb).

### `rfkill list`

**Live output:** [`outputs/network/rfkill.txt`](../outputs/network/rfkill.txt)

Confirms Wi-Fi and Bluetooth are not soft/hard blocked.

---

## Key takeaways

1. **AX201 + iwlwifi + btusb** is a standard Intel laptop stack.
2. Always check **`rfkill`** before debugging “no Wi-Fi”.
3. Redact **MACs, BSSIDs, and IPs** before publishing network dumps.

← [Motherboard](06-motherboard-firmware.md) · [Next: Audio →](08-audio.md)
