# 04 · RAM (Memory)

## Concept

Linux memory accounting is nuanced:

| Term | Meaning |
| :--- | :--- |
| **Total** | Physical RAM visible to the OS |
| **Used** | Actively allocated (definitions vary by tool) |
| **Available** | Estimate of memory available for new apps without swapping (best “free RAM” metric) |
| **Buff/cache** | Page cache — reclaimable under pressure |
| **Swap** | Overflow (disk or **zram** compressed RAM) |

Physical module details (DIMM slots, JEDEC speed, part numbers) live in **SMBIOS** and require `dmidecode` (root).

---

## Commands

### `free -h`

**Live output:** [`outputs/memory/free_h.txt`](../outputs/memory/free_h.txt)

Typical healthy idle laptop: low used, healthy available, swap unused.

### `cat /proc/meminfo`

Kernel counters: `MemTotal`, `MemAvailable`, `Cached`, `Dirty`, `HugePages_*`, `SwapTotal`, etc.

**Live output:** [`outputs/memory/proc_meminfo.txt`](../outputs/memory/proc_meminfo.txt)

Scriptable example:

```bash
awk '/MemAvailable/ {printf "%.1f GiB available\n", $2/1024/1024}' /proc/meminfo
```

### `lsmem`

Shows physical address ranges online/offline and memory block size.

**Live output:** [`outputs/memory/lsmem.txt`](../outputs/memory/lsmem.txt)

**Analysis:** Two online ranges totaling ~7.9 GiB, 128 MiB blocks — matches ~8 GiB system with firmware reservations.

### `vmstat -s`

Event counters: page faults, swap-ins/outs, I/O, interrupts — good for performance baselining.

**Live output:** [`outputs/memory/vmstat_s.txt`](../outputs/memory/vmstat_s.txt)

### `sudo dmidecode --type memory`

**Elevated.** Reports slot count, size per module, speed (e.g. 2666/3200 MT/s), manufacturer, part number, form factor (SODIMM).

**Live output (unprivileged attempt):** [`outputs/memory/dmidecode_memory.txt`](../outputs/memory/dmidecode_memory.txt) — permission denied without root.

```bash
sudo dmidecode --type memory | less
```

---

## Analysis (reference machine)

| Metric | Observation |
| :--- | :--- |
| Usable RAM | ~7.5–7.9 GiB of 8 GiB class system |
| Swap | **zram** ~7.53 GiB (compressed RAM swap) |
| Pressure at capture | Low (~2 GiB used) |

**zram** is excellent on 8 GiB laptops: avoids slow disk swap for light overflow. Watch `zramctl` / `swapon --show` under load.

---

## Key takeaways

1. Prefer **`MemAvailable`** / `free` “available” over raw “free”.
2. **`dmidecode`** is required for true DIMM inventory (single channel vs dual, upgrade options).
3. **zram** is swap, but lives in RAM — do not confuse with disk swap performance characteristics.

← [GPU](03-gpu-display.md) · [Next: Storage →](05-storage.md)
