# EaglerProxy

<a href="https://repl.it/github/WorldEditAxe/eaglerproxy"><img height="30px" src="https://raw.githubusercontent.com/FogNetwork/Tsunami/main/deploy/replit2.svg"><img></a>  

A standalone reimplementation of EaglercraftX's bungee plugin written in TypeScript, with plugin support.

_Working for latest EaglercraftX client version as of `3/12/2025`_

## 📋 Table of Contents

- [Features](#-features)
- [Quick Start with Docker](#-quick-start-with-docker)
- [Manual Installation](#-manual-installation)
- [Configuration](#-configuration)
- [Plugins](#-plugins)
- [Plugin Development](#-plugin-development)
- [Troubleshooting](#-troubleshooting)
- [Known Issues](#-known-issues)
- [Reporting Issues](#-reporting-issues)

## ✨ Features

- 🚀 Fast and lightweight proxy for EaglercraftX clients
- 🔌 Plugin support with easy-to-use API
- 🎮 EagProxyAAS plugin for connecting to vanilla Minecraft servers
- 🐳 Docker support for easy deployment
- 🔧 Highly configurable
- 📦 TypeScript-based with full type safety

## 🐳 Quick Start with Docker

The easiest way to get started is using our interactive setup script with Docker:

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed on your system
- [Docker Compose](https://docs.docker.com/compose/install/) (usually included with Docker Desktop)

### Using the Interactive Setup Script

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sirluky/eaglerproxy.git
   cd eaglerproxy
   ```

2. **Run the setup script:**
   ```bash
   ./setup.sh
   ```

   The script will:
   - Check if Docker is installed
   - Guide you through configuration options
   - Create a `.env` file with your settings
   - Build and start the Docker container

3. **Access your proxy:**
   - Your proxy will be available at `ws://localhost:8080` (or the port you configured)
   - Connect using an EaglercraftX client

### Manual Docker Setup

If you prefer to configure manually:

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Edit `.env` file with your preferred settings:**
   ```bash
   nano .env  # or use your favorite editor
   ```

3. **Start the container:**
   ```bash
   docker compose up -d
   ```

### Docker Management Commands

```bash
# View logs
docker compose logs -f eaglerproxy

# Stop the proxy
docker compose stop

# Start the proxy
docker compose start

# Restart the proxy
docker compose restart

# Stop and remove containers
docker compose down

# Rebuild and restart
docker compose up -d --build
```

### Using Native Modules for Better Performance

By default, the Docker setup uses the standard Dockerfile without native modules for broader compatibility. If you want better performance and have a compatible system, you can create a custom docker-compose configuration:

1. **Create a `docker-compose.native.yml` file:**
   ```yaml
   version: '3.8'
   services:
     eaglerproxy:
       build:
         context: .
         dockerfile: Dockerfile.native
       # ... rest of configuration same as docker-compose.yml
   ```

2. **Update your `.env` file:**
   ```bash
   USE_NATIVES=true
   ```

3. **Start with the native configuration:**
   ```bash
   docker compose -f docker-compose.native.yml up -d
   ```

Note: The native build requires build tools and may not work on all systems.

## 💻 Manual Installation

If you prefer not to use Docker, you can run EaglerProxy directly on your system.

### Prerequisites

- [Node.js](https://nodejs.org/en) LTS (v18 or higher)
- Git
- Basic command line knowledge

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sirluky/eaglerproxy.git
   cd eaglerproxy
   ```

2. **Install dependencies:**
   ```bash
   npm install
   npm install -g typescript
   ```

3. **Configure the proxy:**
   - Edit `src/config.ts` to configure the main proxy settings
   - Edit `src/plugins/EagProxyAAS/config.ts` for plugin-specific settings

4. **Build the project:**
   ```bash
   tsc
   ```

5. **Run the proxy:**
   ```bash
   cd build
   node index.js
   ```

### Important: For Non-Traditional Runtime Environments

For the most part, this proxy (and its dependencies) transpiles to pure JavaScript, and does not require anything more than a full implementation of the Node.js API (with the exception of node-gyp/native support). _Crypto support is required for the proxy to run._

**<u>If you are running the proxy through either Termux or CodeSandbox's on-device runtime:</u>**

1. Uninstall `sharp`, and ensure that `jimp` is installed.
2. Edit `config.ts` and set `adapter.useNatives` to `false`.

The above steps can solve any issues where the proxy immediately crashes with a segfault/illegal instruction error.

## ⚙️ Configuration

EaglerProxy can be configured in two ways:

### 1. Environment Variables (Recommended for Docker)

When using Docker, configure the proxy using environment variables in the `.env` file:

```bash
# Basic Configuration
BIND_HOST=0.0.0.0          # Host to bind to (0.0.0.0 = all interfaces)
BIND_PORT=8080             # Port clients will connect to
MAX_CONCURRENT_CLIENTS=20  # Maximum concurrent connections
USE_NATIVES=true           # Use native modules for better performance

# Default Server
SERVER_HOST=127.0.0.1      # Default Minecraft server host
SERVER_PORT=25565          # Default Minecraft server port

# EagProxyAAS Plugin
ALLOW_CUSTOM_PORTS=true    # Allow clients to specify custom ports
ALLOW_DIRECT_CONNECT=true  # Allow direct connect endpoints
DISALLOW_HYPIXEL=false     # Block connections to Hypixel
SHOW_DISCLAIMERS=false     # Show disclaimer messages

# Authentication (optional)
AUTH_ENABLED=false         # Enable proxy authentication
AUTH_PASSWORD=             # Password for proxy access
```

### 2. Configuration Files (For Manual Installation)

Edit the TypeScript configuration files:

- **`src/config.ts`** - Main proxy configuration
  - Adapter settings (host, port, max clients)
  - Skin server configuration
  - Rate limiting
  - MOTD settings
  - TLS/SSL settings
  - Origin whitelist/blacklist

- **`src/plugins/EagProxyAAS/config.ts`** - EagProxyAAS plugin configuration
  - Internal server settings
  - Custom port allowances
  - Hypixel blocking
  - Authentication settings

## 🔌 Plugins

As of right now, there only exists one plugin: EagProxyAAS (read below for more information).

### EagProxyAAS

EagProxyAAS aims to allow any Eaglercraft client to connect to a normal 1.8.9 Minecraft server, provided that players own a legitimate Minecraft Java copy. Although basic mitigations againt this exist in the plugin, **if you are hosting an instance of this proxy, please take steps to ensure that the proxy cannot access any internal IPs/hostnames as to prevent and mitigate the risk of network enumeration.**

#### Client Support

EagPAAS allows URL parameters to be passed to the proxy in the WebSocket server URL to supply information about the target server, such as the server IP, port, and method of authentication.
Example: `ws://example.com/?ip=example.com&port=25565&authType=[THEALTENING|ONLINE|OFFLINE]`

#### `vanilla://` URL support

A client-sided, Eaglercraft client-agnostic JavaScript shim that adds support for the custom `vanilla://` URL server protocol through URL rewriting is available in `example_plugins/proxy-shimmer.js`. An EaglerProxy server instance running the EagPAAS plugin is required.  
Format (`[]` are optional): `vanilla[+online/+offline/+altening]://hostname[:port]` (`port` defaults to `25565`)

#### I don't want to use this plugin!

Remove all the folders in `src/plugins`.

#### IMPORTANT: READ ME BEFORE USING

EaglerProxy and EagProxyAAS:

- is compatible with EaglercraftX and uses its handshake system,
- intercepts and reads Minecraft packet traffic between you and the server on the other end (necessary for functionality),
- only uses login data to authenticate with vanilla Minecraft servers,
- and is open source and safe to use.

EaglerProxy and EagProxyAAS does NOT:

- include any Microsoft/Mojang code,
- store or otherwise use authentication data for any other purpose as listed on the README,
  - Unmodified versions will not maliciously handle your login data, although a modified version has the ability to do so. Only use trusted and unmodified versions of both this plugin and proxy.
- and intentionally put your account at risk.

## 📚 Plugin Development

### Creating Your Own Plugin

The proxy's software utilizes its own plugin API written in JavaScript, rather than BungeeCord's plugin API. For this reason, plugins written for the official BungeeCord plugin will **not** work on this proxy.

_Refer to `src/plugins/EagProxyAAS` for an example plugin._

Each EaglerProxy plugin consists of two parts:

1. **Entry point JavaScript file** - This file is executed when the plugin is loaded
2. **`metadata.json` file** - Contains plugin metadata

### Plugin metadata.json Structure

```json
{
    "name": "Example Plugin",
    "id": "examplePlugin",
    "version": "1.0.0",
    "entry_point": "index.js",
    "requirements": [{ "id": "otherPlugin", "version": "1.0.0" }],
    "incompatibilities": [{ "id": "someOtherPlugin", "version": "2.0.0" }],
    "load_after": ["otherPlugin"]
}
```

As of right now, there exists no comprehensive API reference. Please refer to the preinstalled plugin for details regarding API usage.

### Disabling Plugins

To disable the EagProxyAAS plugin or other plugins, remove the corresponding folder from `src/plugins/` before building.

## 🔧 Troubleshooting

### Docker Issues

**Problem: "Cannot connect to the Docker daemon"**
- Solution: Make sure Docker is running. On Windows/Mac, start Docker Desktop.

**Problem: Port already in use**
- Solution: Change the `BIND_PORT` in your `.env` file to a different port (e.g., 8081, 8082)

**Problem: Container keeps restarting**
- Solution: Check the logs with `docker compose logs -f eaglerproxy` to see what's wrong

### Build Issues

**Problem: Native module installation fails**
- Solution: Set `USE_NATIVES=false` in your `.env` file or `adapter.useNatives = false` in `config.ts`

**Problem: TypeScript compilation errors**
- Solution: Make sure you have TypeScript installed globally: `npm install -g typescript`

### Connection Issues

**Problem: Clients cannot connect to the proxy**
- Solution: 
  - Check that the proxy is running: `docker compose ps` or check the process
  - Verify the port is correct and not blocked by firewall
  - For cloud deployments, ensure the security group allows the port

**Problem: Proxy cannot connect to Minecraft server**
- Solution:
  - Verify the `SERVER_HOST` and `SERVER_PORT` are correct
  - Check that the Minecraft server is running and accessible
  - For Docker: Use `host.docker.internal` instead of `localhost` to connect to services on the host

### Performance Issues

**Problem: Slow skin loading or proxy performance**
- Solution: 
  - Enable native modules by setting `USE_NATIVES=true`
  - Install build dependencies (for Docker, this is automatic)
  - Increase `MAX_CONCURRENT_CLIENTS` if you have resources available

## 🐛 Known Issues

- **[EagProxyAAS]** Player is missing skin when connected to server
  - Due to Eaglercraft's skin system and how it works, forcing skins onto the client is impossible (from what I know so far). This is only a client-sided bug/glitch - others will only see your Mojang/Minecraft account skin and cape.

## 📝 Reporting Issues

**NOTE:** Issues asking for help will be converted into discussions. You are expected to have **thoroughly** read all documentation prior to asking for help, and expect no help if you have not done so.

- **Security-related bugs/issues:** Directly contact me on Discord (check my profile).
- **Non-security-related bugs/issues:** Open a new issue, with the following:
  - Bug description
  - Affected versions
  - Reproduction steps (optional if you can't find)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License.

## 🔗 Links

- [EaglercraftX](https://eaglercraft.com/)
- [Issue Tracker](https://github.com/sirluky/eaglerproxy/issues)
- [Discussions](https://github.com/sirluky/eaglerproxy/discussions)
