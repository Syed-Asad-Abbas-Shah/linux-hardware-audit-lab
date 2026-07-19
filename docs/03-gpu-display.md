# 03 · GPU (Graphics) & Display

## Concept

Linux graphics is a stack:

```text
Application
  → API (OpenGL / Vulkan / OpenCL / VA-API)
    → Mesa / vendor ICD
      → Kernel DRM driver (i915, amdgpu, nvidia, …)
        → GPU hardware
```

Display servers (**Wayland** or **X11**) own connectors and modes. On this machine: **KWin Wayland** + **Xwayland** for X11 apps.

---

## Commands

### GPU PCI + driver

```bash
lspci -k | grep -A 3 -E "(VGA|3D)"
```

**Live output:** [`outputs/gpu/lspci_vga.txt`](../outputs/gpu/lspci_vga.txt)

**Analysis:** Intel CometLake-U GT2 [UHD Graphics], kernel driver **`i915`**. No discrete NVIDIA/AMD GPU → `nvidia-smi` / `radeontop` are N/A.

### OpenGL — `glxinfo`

```bash
glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"
```

**Live output:** [`outputs/gpu/glxinfo.txt`](../outputs/gpu/glxinfo.txt)

| Field | Value |
| :--- | :--- |
| Vendor | Intel |
| Renderer | Mesa Intel UHD Graphics (CML GT2) |
| Version | OpenGL 4.6 · Mesa 26.1.4 |

Confirms the **iris** Mesa driver path (not software `llvmpipe`).

### Vulkan — `vulkaninfo --summary`

**Live output:** [`outputs/gpu/vulkaninfo.txt`](../outputs/gpu/vulkaninfo.txt)

- Instance version **1.4.350**
- Layers include Gamescope WSI and MangoHud (gaming/debug overlays)
- Physical device: Intel integrated GPU via Mesa Vulkan (`anv` family)

### OpenCL — `clinfo`

**Live output:** [`outputs/gpu/clinfo.txt`](../outputs/gpu/clinfo.txt)

Lists compute units, max work-group sizes, and extensions for GPGPU workloads (video filters, compute apps).

### Display modes — `xrandr` / `kscreen-doctor -l`

**Live outputs:**

- [`outputs/gpu/xrandr.txt`](../outputs/gpu/xrandr.txt)
- [`outputs/gpu/kscreen_doctor.txt`](../outputs/gpu/kscreen_doctor.txt)

**Analysis:** Built-in **eDP-1** primary at **1920×1080 @ ~60 Hz**, physical size ~309×174 mm (14″ class panel). On pure Wayland, prefer `kscreen-doctor` / DE settings; `xrandr` talks to Xwayland and may not control all native Wayland outputs.

### Vendor monitors (not applicable / interactive)

| Tool | Role |
| :--- | :--- |
| `nvidia-smi` | NVIDIA only — not present |
| `nvtop` | Interactive multi-vendor GPU process view |
| `intel_gpu_top` | Intel engine utilization (render/blitter/video) |
| `radeontop` | AMD only |

---

## Key takeaways

1. This is a **single-GPU Intel iGPU** laptop — simpler driver story than hybrid graphics.
2. **Mesa 26.x** provides OpenGL 4.6 and modern Vulkan on Comet Lake UHD.
3. Prefer **Wayland-native** tools for display topology on Plasma 6.
4. For media encode/decode checks, also inspect VA-API (`vainfo`) if installed.

← [CPU](02-cpu.md) · [Next: Memory →](04-memory.md)
