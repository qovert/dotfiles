#!/usr/bin/env bash
# Waybar module: one CPU% + RAM tile. Runs as a loop (no "interval") so CPU
# usage is the delta between samples. Click opens sysstats-menu.
# RAM leaves out the ZFS ARC: the kernel counts it as used, but ZFS hands it
# back under memory pressure.
arc=/proc/spl/kstat/zfs/arcstats
read -r _ u n s i w q sq st _ < /proc/stat
prev_total=$((u + n + s + i + w + q + sq + st)) prev_idle=$((i + w))

while true; do
    sleep 2
    read -r _ u n s i w q sq st _ < /proc/stat
    total=$((u + n + s + i + w + q + sq + st)) idle=$((i + w))
    dt=$((total - prev_total)) di=$((idle - prev_idle))
    cpu=$(( dt > 0 ? (100 * (dt - di)) / dt : 0 ))
    prev_total=$total prev_idle=$idle

    arc_kb=0
    [[ -r $arc ]] && arc_kb=$(awk '$1 == "size" {print int($3 / 1024)}' "$arc")
    used_kb=$(awk -v z="$arc_kb" '/^MemTotal/ {t=$2} /^MemAvailable/ {a=$2} END {print t - a - z}' /proc/meminfo)
    ram=$(awk -v k="$used_kb" 'BEGIN {printf "%.0f", k / 1048576}')

    class=""
    (( cpu >= 90 )) && class="busy"
    printf '{"text":"\U000F0EE0  %s%%   \U000F035B  %sG","tooltip":"CPU %s%% · RAM %s GiB used\\nClick for details","class":"%s"}\n' \
        "$cpu" "$ram" "$cpu" "$ram" "$class"
done
