#!/usr/bin/env bash
# Waybar module: amdgpu load and junction temperature.
dev=$(dirname "$(ls /sys/class/drm/card*/device/gpu_busy_percent 2>/dev/null | head -1)")
[[ -d $dev ]] || exit 0
busy=$(<"$dev/gpu_busy_percent")
for label in "$dev"/hwmon/hwmon*/temp*_label; do
    if [[ $(<"$label") == junction ]]; then
        temp=$(( $(<"${label%_label}_input") / 1000 ))
    fi
done
class=""
(( ${temp:-0} >= 95 )) && class="hot"
printf '{"text":"GPU %s%% %s°C","tooltip":"RX 7800 XT load %s%%, junction %s°C","class":"%s"}\n' \
    "$busy" "${temp:-?}" "$busy" "${temp:-?}" "$class"
