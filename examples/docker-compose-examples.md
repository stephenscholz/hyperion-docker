# Docker Compose Examples for Hyperion.ng

This directory contains example docker-compose configurations for different use cases.

## Basic Setup (docker-compose.yml in root)

The main `docker-compose.yml` in the root directory provides a basic setup with:
- Host network mode for easy device discovery
- Privileged mode for hardware access
- Volume for configuration persistence

## Advanced Examples

### Bridge Network Mode

If you don't need host network mode:

```yaml
version: '3.8'

services:
  hyperion:
    build: .
    container_name: hyperion
    restart: unless-stopped
    
    ports:
      - "8090:8090"
      - "19444:19444"
      - "19445:19445"
      - "19400:19400"
      - "2100:2100"
    
    volumes:
      - ./config:/opt/hyperion/config
    
    environment:
      - TZ=Europe/London
```

### With Specific Device Access

For better security, grant access to specific devices only:

```yaml
version: '3.8'

services:
  hyperion:
    build: .
    container_name: hyperion
    restart: unless-stopped
    network_mode: host
    
    volumes:
      - ./config:/opt/hyperion/config
    
    devices:
      - /dev/spidev0.0:/dev/spidev0.0
      - /dev/ttyUSB0:/dev/ttyUSB0
      - /dev/video0:/dev/video0
    
    environment:
      - TZ=Europe/London
```

### With External Network

To connect to other services:

```yaml
version: '3.8'

networks:
  smart-home:
    external: true

services:
  hyperion:
    build: .
    container_name: hyperion
    restart: unless-stopped
    
    networks:
      - smart-home
    
    ports:
      - "8090:8090"
      - "19444:19444"
    
    volumes:
      - ./config:/opt/hyperion/config
    
    environment:
      - TZ=Europe/London
```

### Development Mode

For development with local source:

```yaml
version: '3.8'

services:
  hyperion-dev:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        HYPERION_VERSION: development
    container_name: hyperion-dev
    restart: "no"
    
    network_mode: host
    privileged: true
    
    volumes:
      - ./config:/opt/hyperion/config
      - ./logs:/var/log/hyperion
    
    environment:
      - TZ=Europe/London
      - DEBUG=true
```

## Usage

1. Choose the configuration that fits your needs
2. Copy it to `docker-compose.yml` in the root directory
3. Customize as needed
4. Run with:
   ```bash
   docker-compose up -d
   ```

## Tips

- Use `network_mode: host` for best compatibility with LED device discovery
- Use `privileged: true` only if necessary for your hardware
- Always set your timezone with the `TZ` environment variable
- Mount `/dev` directory for access to all devices (requires privileged mode)
