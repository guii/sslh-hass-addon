# sslh - Applicative Protocol Multiplexer

This add-on runs [sslh](https://www.rutschle.net/tech/sslh/README.html), a protocol demultiplexer that lets you share a single port (typically 443) across multiple services.

## How it works

sslh listens on a single port and inspects the first data packet from each incoming connection to determine the protocol. It then forwards the connection to the appropriate backend service.

Supported protocols:
- **SSH** - Secure Shell
- **TLS/SSL** - HTTPS and any TLS-wrapped protocol (supports SNI/ALPN)
- **HTTP** - Plain HTTP
- **OpenVPN** - OpenVPN tunneling
- **XMPP** - Jabber/XMPP instant messaging
- **SOCKS5** - SOCKS proxy
- **tinc** - tinc VPN
- **TeamSpeak** - TeamSpeak 3 voice
- **adb** - Android Debug Bridge
- **anyprot** - Catch-all fallback

## Configuration

### Option: `listen_host`

The IP address sslh should bind to. Use `0.0.0.0` to listen on all interfaces, or specify a specific interface IP.

### Option: `listen_port`

The single port on which sslh will accept connections. Default is `443`.

### Option: `verbose`

Enable detailed logging of protocol probing and connection routing. Useful for troubleshooting.

### Option: `timeout`

Seconds to wait before the protocol detection times out. Default is `2`.

### Option: `protocols`

A list of protocol entries. Each entry has:

| Field | Description |
|-------|-------------|
| `name` | Protocol to detect (ssh, tls, http, openvpn, xmpp, socks5, tinc, adb, teamspeak, anyprot) |
| `host` | Target host to forward matched connections to |
| `port` | Target port on the destination host |
| `enabled` | Whether this protocol forwarding rule is active |

## Example: Share SSH and HTTPS on port 443

The default configuration listens on port 443 and forwards:
- SSH connections to `127.0.0.1:22`
- TLS/HTTPS connections to `127.0.0.1:443`

This allows you to SSH into your Home Assistant instance through port 443, even if your firewall blocks port 22.

## Notes

- This add-on uses `host_network` mode so it can bind directly to host ports.
- Make sure no other service is using the configured listen port.
- Protocol probes are evaluated in order. Put more specific protocols first.
- For advanced configurations, you can place a custom `sslh.cfg` file in the addon config folder (`/addon_configs/a0d7b954_sslh/`) and it will be used instead of the generated one.
