# 02 · CPU (Processor)

## Concept

The CPU is exposed to userspace mainly through:

- **`/proc/cpuinfo`** — per-logical-CPU attributes and feature flags  
- **sysfs topology** — core/package/cache IDs under `/sys/devices/system/cpu/`  
- **cpufreq / intel_pstate** — frequency scaling and energy policy  
- **CPU feature flags** — AES-NI, AVX2, VT-x, mitigation bits, etc.

**Logical CPUs ≠ physical cores.** Hyper-Threading (SMT) presents two threads per core.

---

## Commands

### `lscpu`

Primary human-readable CPU inventory.

**Live output:** [`outputs/cpu/lscpu.txt`](../outputs/cpu/lscpu.txt)

**Analysis:**

| Attribute | Value | Meaning |
| :--- | :--- | :--- |
| Model | Intel Core i7-10610U @ 1.80 GHz | Comet Lake-U mobile |
| Topology | 1 socket · 4 cores · 2 threads | 8 logical CPUs |
| Freq range | 400 MHz – 4900 MHz | Deep C-states + turbo boost |
| Caches | L1d/i 128 KiB · L2 1 MiB · L3 8 MiB | Shared L3 across package |
| Virtualization | VT-x | Hardware VM support |
| Address sizes | 39-bit phys / 48-bit virt | Typical for this generation |

Also lists **Spectre/Meltdown-class mitigations** — useful for security audits.

### `cat /proc/cpuinfo`

Raw per-logical-CPU dump (repeated 8 times here). Best for scripting feature detection:

```bash
grep -m1 'model name' /proc/cpuinfo
grep -o 'vmx' /proc/cpuinfo | head -1   # VT-x present
```

**Live output:** [`outputs/cpu/proc_cpuinfo.txt`](../outputs/cpu/proc_cpuinfo.txt)

### `lscpu --extended` / custom columns

Shows which logical CPUs share caches and cores — critical for pinning and NUMA-aware apps.

**Live outputs:**

- [`outputs/cpu/lscpu_extended.txt`](../outputs/cpu/lscpu_extended.txt)
- [`outputs/cpu/lscpu_cache.txt`](../outputs/cpu/lscpu_cache.txt)

### `cpupower frequency-info`

Reports the active **cpufreq driver**, governors, hardware limits, and energy preference.

**Live output:** [`outputs/cpu/cpupower.txt`](../outputs/cpu/cpupower.txt)

**Analysis:**

| Item | Observed |
| :--- | :--- |
| Driver | `intel_pstate` |
| Governors | `performance`, `powersave` |
| Active policy | `powersave` |
| EPP | `balance_power` |
| Boost | Supported and active |
| Limits | 400 MHz – 4.90 GHz |

On battery, `powersave` + `balance_power` is expected. For benchmarks, switch to performance:

```bash
sudo cpupower frequency-set -g performance
```

### `lstopo` (hwloc)

Maps packages, cores, PUs, caches, and nearby PCI devices (GPU, NVMe, NIC).

**Live output:** [`outputs/cpu/lstopo.txt`](../outputs/cpu/lstopo.txt)

Shows 4 cores × 2 PUs under one L3 (8 MiB), ~7.7 GiB NUMA node, with VGA / Wi-Fi / NVMe attached under the host bridge.

---

## Key takeaways

1. **i7-10610U** is a 15 W-class U-series chip: strong single-thread turbo, limited multi-core sustained power.
2. Always check **mitigation lines** in `lscpu` for security baselines.
3. **`intel_pstate` + EPP** is the modern Intel power control path on this platform.
4. Use **`lstopo`** when debugging cache-local performance or device locality.

← [System](01-system-summary.md) · [Next: GPU →](03-gpu-display.md)
