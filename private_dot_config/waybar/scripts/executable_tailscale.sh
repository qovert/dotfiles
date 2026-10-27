#!/usr/bin/env bash
# Waybar module: Tailscale state and this machine's tailnet IP.
status=$(tailscale status --json 2>/dev/null) || status='{}'
state=$(jq -r '.BackendState // "Stopped"' <<<"$status")
if [[ $state == Running ]]; then
    ip=$(jq -r '.Self.TailscaleIPs[0] // ""' <<<"$status")
    peers=$(jq '[.Peer // {} | .[] | select(.Online)] | length' <<<"$status")
    printf '{"text":"󰖂","tooltip":"Tailscale up: %s\\n%s peers online","class":"on"}\n' "$ip" "$peers"
else
    printf '{"text":"󰖂","tooltip":"Tailscale: %s","class":"off"}\n' "$state"
fi
