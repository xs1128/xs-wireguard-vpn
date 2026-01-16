# WireGuard VPN Setup

Credit && Source: https://barrowclift.me/articles/wireguard-server-on-macos

Personal WireGuard VPN configuration for macOS with dual-stack (IPv4/IPv6) support, NAT, and DNS leak protection.

## Features

- WireGuard VPN tunneling
- IPv4 and IPv6 dual-stack support
- Network Address Translation (NAT) for multiple clients
- DNS leak prevention (Cloudflare DNS)
- Automatic firewall configuration via pf
- Dynamic network interface detection (no hardcoded interface names)
- Connection logging to `/var/log/wireguard.log`
- Health check command for monitoring

## Requirements

- macOS server with direct internet connection (public IP) or configure router port forwarding for UDP 51820
- WireGuard tools: `brew install wireguard-tools wireguard-go`

## Setup

1. Generate key pairs for server and clients:
   ```bash
   wg genkey | tee privatekey | wg pubkey > publickey
   ```

2. Update `coordinates.conf` with your keys and IP addresses

3. Copy scripts to WireGuard directory:
   ```bash
   mkdir -p /opt/homebrew/etc/wireguard/
   cp postup.sh postdown.sh /opt/homebrew/etc/wireguard/
   chmod +x /opt/homebrew/etc/wireguard/{postup,postdown}.sh
   ```

4. Install health check command:
   ```bash
   sudo cp wg-healthcheck.sh /opt/homebrew/bin/wg-healthcheck
   sudo chmod +x /opt/homebrew/bin/wg-healthcheck
   ```

5. Configure router port forwarding for UDP port 51820 (if behind NAT/router)

## Usage

Start VPN:
```bash
sudo wg-quick up coordinates.conf
```

Stop VPN:
```bash
sudo wg-quick down coordinates.conf
```

Check WireGuard status:
```bash
sudo wg show
```

Check connection health:
```bash
sudo wg-healthcheck
```
Output: `{"status":"up","interface":"utun9","peers":2,"handshake":"2025-01-16 12:34:56"}`

View logs:
```bash
tail -f /var/log/wireguard.log
```

## Files

- `coordinates.conf` - WireGuard configuration
- `postup.sh` - Startup script (enables IP forwarding, configures NAT with dynamic interface detection)
- `postdown.sh` - Shutdown script (cleans up firewall rules)
- `wg-healthcheck.sh` - Health check script (JSON output for monitoring)
