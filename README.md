# WireGuard VPN Setup

Credit && Source: https://barrowclift.me/articles/wireguard-server-on-macos

Personal WireGuard VPN configuration for macOS with dual-stack (IPv4/IPv6) support, NAT, and DNS leak protection.

## Features

- WireGuard VPN tunneling
- IPv4 and IPv6 dual-stack support
- Network Address Translation (NAT) for multiple clients
- DNS leak prevention (Cloudflare DNS)
- Automatic firewall configuration via pf

## Requirements

- macOS
- WireGuard tools: `brew install wireguard-tools wireguard-go`
- Router with port forwarding (port 51820)

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

4. Configure router port forwarding for UDP port 51820

## Usage

Start VPN:
```bash
wg-quick up coordinates.conf
```

Stop VPN:
```bash
wg-quick down coordinates.conf
```

## Files

- `coordinates.conf` - WireGuard configuration
- `postup.sh` - Startup script (enables IP forwarding, configures NAT)
- `postdown.sh` - Shutdown script (cleans up firewall rules)
