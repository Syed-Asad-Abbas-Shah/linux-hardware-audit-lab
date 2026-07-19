#!/usr/bin/env bash
# Asad Linux Hardware Audit Lab — collection script
# Author: Syed Asad Abbas Shah
# Usage:
#   ./scripts/collect-hardware-info.sh
#   sudo ./scripts/collect-hardware-info.sh --with-sudo

set -u
WITH_SUDO=0
for arg in "$@"; do
  case "$arg" in
    --with-sudo) WITH_SUDO=1 ;;
    -h|--help)
      sed -n '2,8p' "$0"
      exit 0
      ;;
  esac
done

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT/outputs"
STAMP="$(date -Iseconds)"
mkdir -p "$OUT"/{system,cpu,gpu,memory,storage,motherboard,network,audio,usb,sensors,power,pci,kernel}

have() { command -v "$1" >/dev/null 2>&1; }

run_to() {
  local file="$1"; shift
  {
    echo "\$ $*"
    echo "captured: $STAMP"
    echo "---"
    "$@" 2>&1 || echo "[command exit: $?]"
  } > "$file"
  echo "  → ${file#$ROOT/}"
}

echo "== Asad Hardware Audit Collector =="
echo "Output directory: $OUT"
echo

# --- System ---
echo "[system]"
have inxi && run_to "$OUT/system/inxi_Fz.txt" inxi -Fz --color=0
have inxi && run_to "$OUT/system/inxi_Fxz.txt" inxi -Fxz --color=0
have fastfetch && run_to "$OUT/system/fastfetch.txt" fastfetch
have hostnamectl && run_to "$OUT/system/hostnamectl.txt" hostnamectl
run_to "$OUT/system/uname_a.txt" uname -a
if [[ $WITH_SUDO -eq 1 ]]; then
  have lshw && run_to "$OUT/system/lshw_short.txt" lshw -short
  have lshw && run_to "$OUT/system/lshw.html" lshw -html
fi

# --- CPU ---
echo "[cpu]"
run_to "$OUT/cpu/lscpu.txt" lscpu
run_to "$OUT/cpu/proc_cpuinfo.txt" cat /proc/cpuinfo
run_to "$OUT/cpu/lscpu_extended.txt" lscpu --extended
run_to "$OUT/cpu/lscpu_cache.txt" lscpu -e=CPU,NODE,SOCKET,CORE,CACHE
have cpupower && run_to "$OUT/cpu/cpupower.txt" cpupower frequency-info
have lstopo && run_to "$OUT/cpu/lstopo.txt" lstopo --of console

# --- GPU ---
echo "[gpu]"
{
  echo "\$ lspci -k | grep -A 3 -E \"(VGA|3D)\""
  echo "captured: $STAMP"
  echo "---"
  lspci -k | grep -A 3 -E "(VGA|3D)" || true
} > "$OUT/gpu/lspci_vga.txt"
have glxinfo && run_to "$OUT/gpu/glxinfo.txt" bash -c 'glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"'
have vulkaninfo && run_to "$OUT/gpu/vulkaninfo.txt" vulkaninfo --summary
have clinfo && run_to "$OUT/gpu/clinfo.txt" clinfo
have xrandr && run_to "$OUT/gpu/xrandr.txt" xrandr
have kscreen-doctor && run_to "$OUT/gpu/kscreen_doctor.txt" kscreen-doctor -l
have nvidia-smi && run_to "$OUT/gpu/nvidia_smi.txt" nvidia-smi

# --- Memory ---
echo "[memory]"
run_to "$OUT/memory/free_h.txt" free -h
run_to "$OUT/memory/proc_meminfo.txt" cat /proc/meminfo
have lsmem && run_to "$OUT/memory/lsmem.txt" lsmem
run_to "$OUT/memory/vmstat_s.txt" vmstat -s
if [[ $WITH_SUDO -eq 1 ]] && have dmidecode; then
  run_to "$OUT/memory/dmidecode_memory.txt" dmidecode --type memory
fi

# --- Storage ---
echo "[storage]"
run_to "$OUT/storage/lsblk.txt" lsblk -e7 -o NAME,SIZE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL
run_to "$OUT/storage/findmnt.txt" findmnt
run_to "$OUT/storage/df_hT.txt" df -hT
if [[ $WITH_SUDO -eq 1 ]]; then
  have nvme && run_to "$OUT/storage/nvme_list.txt" nvme list
  if have smartctl; then
    for dev in /dev/nvme0n1 /dev/sda /dev/nvme0; do
      [[ -e $dev ]] || continue
      base=$(basename "$dev")
      run_to "$OUT/storage/smartctl_i_${base}.txt" smartctl -i "$dev"
      run_to "$OUT/storage/smartctl_A_${base}.txt" smartctl -A "$dev"
    done
  fi
fi

# --- Motherboard ---
echo "[motherboard]"
if [[ -d /sys/firmware/efi ]]; then
  run_to "$OUT/motherboard/efi_check.txt" ls -la /sys/firmware/efi
else
  echo "Legacy BIOS (no /sys/firmware/efi)" > "$OUT/motherboard/efi_check.txt"
fi
have bootctl && run_to "$OUT/motherboard/bootctl.txt" bootctl status
if [[ $WITH_SUDO -eq 1 ]] && have dmidecode; then
  run_to "$OUT/motherboard/dmidecode_baseboard.txt" dmidecode -t baseboard
  run_to "$OUT/motherboard/dmidecode_bios.txt" dmidecode -t bios
  run_to "$OUT/motherboard/dmidecode_system.txt" dmidecode -t system
  run_to "$OUT/motherboard/dmidecode_chassis.txt" dmidecode -t chassis
fi

# --- Network ---
echo "[network]"
{
  echo "\$ lspci -k | grep -A 3 -i network"
  echo "captured: $STAMP"
  echo "---"
  lspci -k | grep -A 3 -i network || true
} > "$OUT/network/lspci_network.txt"
run_to "$OUT/network/ip_link.txt" ip link show
run_to "$OUT/network/ip_addr.txt" ip addr show
have iwctl && run_to "$OUT/network/iwctl.txt" iwctl device list
have nmcli && run_to "$OUT/network/nmcli_device.txt" nmcli device
have bluetoothctl && run_to "$OUT/network/bluetoothctl.txt" bluetoothctl show
have rfkill && run_to "$OUT/network/rfkill.txt" rfkill list

# --- Audio ---
echo "[audio]"
{
  echo "\$ lspci -k | grep -A 3 -i audio"
  echo "captured: $STAMP"
  echo "---"
  lspci -k | grep -A 3 -i audio || true
} > "$OUT/audio/lspci_audio.txt"
have wpctl && run_to "$OUT/audio/wpctl.txt" wpctl status
have pactl && run_to "$OUT/audio/pactl_sinks.txt" pactl list short sinks
have aplay && run_to "$OUT/audio/aplay_l.txt" aplay -l

# --- USB ---
echo "[usb]"
run_to "$OUT/usb/lsusb.txt" lsusb
run_to "$OUT/usb/lsusb_t.txt" lsusb -t

# --- Sensors ---
echo "[sensors]"
have sensors && run_to "$OUT/sensors/sensors_out.txt" sensors
{
  echo "\$ thermal zones"
  echo "captured: $STAMP"
  echo "---"
  for z in /sys/class/thermal/thermal_zone*/; do
    [[ -d $z ]] || continue
    echo "=== $z ==="
    cat "${z}type" 2>/dev/null || true
    cat "${z}temp" 2>/dev/null || true
  done
} > "$OUT/sensors/thermal_zones.txt"

# --- Power ---
echo "[power]"
if have upower; then
  run_to "$OUT/power/upower_devices.txt" upower -e
  {
    echo "\$ upower -i (all devices)"
    echo "captured: $STAMP"
    echo "---"
    for d in $(upower -e); do
      echo "=== $d ==="
      upower -i "$d"
    done
  } > "$OUT/power/upower_battery.txt"
fi
have acpi && run_to "$OUT/power/acpi.txt" acpi -bi
[[ $WITH_SUDO -eq 1 ]] && have tlp-stat && run_to "$OUT/power/tlp_stat_b.txt" tlp-stat -b

# --- PCI ---
echo "[pci]"
run_to "$OUT/pci/lspci.txt" lspci
run_to "$OUT/pci/lspci_tv.txt" lspci -tv
if [[ $WITH_SUDO -eq 1 ]]; then
  run_to "$OUT/pci/lspci_vvv.txt" lspci -vvv
else
  run_to "$OUT/pci/lspci_vvv.txt" bash -c 'lspci -vvv 2>&1 | head -500'
fi

# --- Kernel ---
echo "[kernel]"
run_to "$OUT/kernel/lsmod.txt" lsmod
if [[ $WITH_SUDO -eq 1 ]]; then
  {
    echo "\$ dmesg | hardware filter"
    echo "captured: $STAMP"
    echo "---"
    dmesg | grep -i -E "(error|fail|warn|firmware)" | tail -100 || true
  } > "$OUT/kernel/dmesg_hw.txt"
else
  {
    echo "\$ journalctl -k (fallback, no raw dmesg)"
    echo "captured: $STAMP"
    echo "---"
    journalctl -k -b --no-pager 2>/dev/null | grep -i -E "(error|fail|warn|firmware)" | tail -100 \
      || echo "dmesg/journal not fully readable without privileges"
  } > "$OUT/kernel/dmesg_hw.txt"
fi
have fwupdmgr && run_to "$OUT/kernel/fwupdmgr.txt" fwupdmgr get-devices

echo
echo "Done. Review outputs/ before publishing (redact MACs, IPs, serials)."
echo "Tip: publish only after scrubbing privacy-sensitive fields."
