# 09 · USB Devices & Controller Tree

## Concept

USB is hierarchical:

```text
Root hub (xHCI)
  └─ hubs / devices
       └─ interfaces (HID, UVC, Bluetooth, storage, …)
```

Speeds you will see in `lsusb -t`:

| Label | Generation |
| :--- | :--- |
| 1.5M / 12M | USB 1.x |
| 480M | USB 2.0 |
| 5000M | USB 3.0/3.1 Gen1 |
| 10000M | USB 3.1 Gen2 / 3.2 |

---

## Commands

### `lsusb`

**Live output:** [`outputs/usb/lsusb.txt`](../outputs/usb/lsusb.txt)

| ID | Device |
| :--- | :--- |
| `0408:5347` | Quanta HP HD Camera |
| `06cb:00df` | Synaptics fingerprint reader |
| `8087:0026` | Intel AX201 Bluetooth |
| `1d6b:0002/0003` | Linux root hubs (USB2/USB3) |

Extra root hubs correspond to the **Thunderbolt 3 USB controller** path.

### `lsusb -t`

**Live output:** [`outputs/usb/lsusb_t.txt`](../outputs/usb/lsusb_t.txt)

Tree view with speeds — use this to confirm a “USB 3” device actually negotiated SuperSpeed.

### `sudo lsusb -v`

Verbose descriptors (power, endpoints, class codes). Large output; sample truncated:

**Live output:** [`outputs/usb/lsusb_v.txt`](../outputs/usb/lsusb_v.txt)

---

## Key takeaways

1. Built-in camera, fingerprint, and BT all appear as **USB devices**, not PCI.
2. Thunderbolt adds additional **xHCI** controllers to the tree.
3. Verbose dumps can include serials — redact before publishing.

← [Audio](08-audio.md) · [Next: Sensors →](10-sensors.md)
