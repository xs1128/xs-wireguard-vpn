#!/bin/bash
# WireGuard health check - returns JSON for monitoring

LOG_FILE="/var/log/wireguard.log"
INTERFACE="utun9"

# Check if WireGuard interface is up
if ! ifconfig "$INTERFACE" >/dev/null 2>&1; then
    echo '{"status":"down","interface":"'${INTERFACE}'","message":"Interface not found"}'
    exit 1
fi

# Check if listening on port 51820
if ! lsof -i UDP:51820 >/dev/null 2>&1; then
    echo '{"status":"error","interface":"'${INTERFACE}'","message":"Not listening on 51820"}'
    exit 1
fi

# Get peer info
PEER_COUNT=$(sudo wg show "$INTERFACE" peers 2>/dev/null | wc -l | tr -d ' ')
HANDSHAKE=$(sudo wg show "$INTERFACE" latest-handshakes 2>/dev/null | head -1 | awk '{print $2}')

if [ -z "$HANDSHAKE" ] || [ "$HANDSHAKE" = "0" ]; then
    echo '{"status":"up","interface":"'${INTERFACE}'","peers":'${PEER_COUNT}',"handshake":"none"}'
else
    LAST_HS=$(date -r "$HANDSHAKE" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo "unknown")
    echo '{"status":"up","interface":"'${INTERFACE}'","peers":'${PEER_COUNT}',"handshake":"'${LAST_HS}'"}'
fi
