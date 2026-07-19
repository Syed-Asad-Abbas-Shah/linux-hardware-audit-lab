# 08 · Audio & Sound Devices

## Concept

Modern Linux audio path:

```text
Apps → PipeWire / PulseAudio API
         → PipeWire graph
           → ALSA PCM devices
             → Kernel codec driver (SOF / HDA / USB)
               → Speakers / HDMI / headset jack
```

Intel laptops increasingly use **SOF** (Sound Open Firmware) instead of legacy `snd_hda_intel` alone.

---

## Commands

### PCI audio controller

```bash
lspci -k | grep -A 3 -i audio
```

**Live output:** [`outputs/audio/lspci_audio.txt`](../outputs/audio/lspci_audio.txt)

| Field | Value |
| :--- | :--- |
| Device | Intel 400 Series On-Package HD Audio |
| Driver in use | `sof-audio-pci-intel-cnl` |
| Modules | `snd_sof_pci_intel_cnl`, `snd_hda_intel`, … |

### USB audio

```bash
lsusb | grep -i audio
```

**Live output:** [`outputs/audio/lsusb_audio.txt`](../outputs/audio/lsusb_audio.txt) — no USB DAC matched at capture.

### PipeWire — `wpctl status`

**Live output:** [`outputs/audio/wpctl.txt`](../outputs/audio/wpctl.txt)

Shows sinks (outputs), sources (mics), and default devices in the PipeWire session.

### Pulse-compatible sinks — `pactl list short sinks`

**Live output:** [`outputs/audio/pactl_sinks.txt`](../outputs/audio/pactl_sinks.txt)

### ALSA hardware — `aplay -l`

**Live output:** [`outputs/audio/aplay_l.txt`](../outputs/audio/aplay_l.txt)

```text
card 0: sofhdadsp [sof-hda-dsp]
  device 0: HDA Analog
  device 3–5: HDMI 1–3
  device 31: HDA Analog Deep Buffer
```

Analog laptop speakers/headphones + HDMI audio endpoints are present.

---

## Key takeaways

1. **SOF + PipeWire** is the correct healthy stack for this Comet Lake HP.
2. If audio fails, check `dmesg | grep -i sof`, firmware packages, and `wpctl status` before reinstalling apps.
3. HDMI devices appear even when no external display is connected.

← [Network](07-network-bluetooth.md) · [Next: USB →](09-usb.md)
