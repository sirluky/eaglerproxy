# Docker Setup Guide for EaglerProxy

This guide explains the Docker setup added to EaglerProxy for easy deployment and configuration.

## Quick Start

1. Run the interactive setup script:
   ```bash
   ./setup.sh
   ```

2. The script will:
   - Check if Docker is installed
   - Ask you configuration questions
   - Create a `.env` file
   - Build and start the Docker container

## Files Added

- **`setup.sh`** - Interactive setup script that guides you through configuration
- **`Dockerfile`** - Standard Docker image (compatible, no native modules)
- **`Dockerfile.native`** - Docker image with native modules for better performance
- **`docker-compose.yml`** - Docker Compose configuration
- **`.env.example`** - Example environment variables file
- **`.dockerignore`** - Files to exclude from Docker build

## Configuration

All configuration is done via environment variables in the `.env` file:

### Basic Settings
- `ADAPTER_NAME` - Name of the proxy (default: EaglerProxy)
- `BIND_HOST` - Host to bind to (default: 0.0.0.0)
- `BIND_PORT` - Port for clients to connect (default: 8080)
- `MAX_CONCURRENT_CLIENTS` - Maximum concurrent connections (default: 20)
- `USE_NATIVES` - Use native modules for better performance (default: true)

### Server Settings
- `SERVER_HOST` - Default Minecraft server host (default: 127.0.0.1)
- `SERVER_PORT` - Default Minecraft server port (default: 1111)

### EagProxyAAS Plugin Settings
- `ALLOW_CUSTOM_PORTS` - Allow clients to specify custom ports (default: true)
- `ALLOW_DIRECT_CONNECT` - Allow direct connect endpoints (default: true)
- `DISALLOW_HYPIXEL` - Block connections to Hypixel (default: false)
- `SHOW_DISCLAIMERS` - Show disclaimer messages (default: false)

### Authentication
- `AUTH_ENABLED` - Enable proxy authentication (default: false)
- `AUTH_PASSWORD` - Password for proxy access

## Manual Docker Setup

If you prefer not to use the setup script:

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` with your settings:
   ```bash
   nano .env
   ```

3. Start the container:
   ```bash
   docker compose up -d
   ```

## Docker Commands

### Basic Operations
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

### Using Native Modules

For better performance (requires compatible system):

1. Build using the native Dockerfile:
   ```bash
   docker build -f Dockerfile.native -t eaglerproxy:native .
   ```

2. Create a custom docker-compose override file `docker-compose.native.yml`:
   ```yaml
   version: '3.8'
   services:
     eaglerproxy:
       image: eaglerproxy:native
   ```

3. Set in `.env`:
   ```bash
   USE_NATIVES=true
   ```

4. Start with both compose files:
   ```bash
   docker compose -f docker-compose.yml -f docker-compose.native.yml up -d
   ```

## Troubleshooting

### Port Already in Use
Change `BIND_PORT` in your `.env` file to a different port.

### Container Keeps Restarting
Check logs: `docker compose logs -f eaglerproxy`

### Cannot Connect to Minecraft Server from Docker
Use `host.docker.internal` instead of `localhost` in `SERVER_HOST` to connect to services on the host machine.

### Native Module Build Fails
Use the standard Dockerfile and set `USE_NATIVES=false` in your `.env` file.

## Benefits of Docker Setup

1. **Easy Deployment** - One command to get started
2. **Isolated Environment** - No conflicts with system packages
3. **Portable** - Works the same on any system with Docker
4. **Persistent Data** - Skin cache is stored in Docker volumes
5. **Easy Updates** - Just rebuild the image

## Source Code Changes

The following source files were updated to support environment variables:
- `src/config.ts` - Main proxy configuration
- `src/plugins/EagProxyAAS/config.ts` - Plugin configuration

These changes are backward compatible - the defaults work without environment variables.
