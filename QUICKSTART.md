# Quick Start Guide

Get Hyperion.ng running in Docker in under 5 minutes!

## Prerequisites

- Docker installed on your system
- Docker Compose installed (or Docker Desktop)
- 2GB of free disk space for the build

## 1. Clone the Repository

```bash
git clone https://github.com/stephenscholz/hyperion-docker.git
cd hyperion-docker
```

## 2. Start Hyperion

### Option A: Using Docker Compose (Recommended)

```bash
docker-compose up -d
```

### Option B: Using Makefile

```bash
make build
make up
```

## 3. Access the Web Interface

Open your browser and navigate to:

```
http://localhost:8090
```

## 4. Configure Your LEDs

1. Open the web interface at http://localhost:8090
2. Follow the setup wizard to configure your LED hardware
3. Test your LED configuration
4. Enjoy your ambient lighting!

## Common Commands

### Using Docker Compose

```bash
# Start Hyperion
docker-compose up -d

# Stop Hyperion
docker-compose down

# View logs
docker-compose logs -f

# Restart Hyperion
docker-compose restart

# View running containers
docker-compose ps
```

### Using Makefile

```bash
# Build the image
make build

# Start Hyperion
make up

# Stop Hyperion
make down

# View logs
make logs

# Restart
make restart

# Backup configuration
make backup

# Show all available commands
make help
```

## Troubleshooting

### Container won't start

Check the logs:
```bash
docker-compose logs
```

### Can't access the web interface

1. Ensure the container is running:
   ```bash
   docker-compose ps
   ```

2. Check if port 8090 is accessible:
   ```bash
   curl http://localhost:8090
   ```

3. Check your firewall settings

### Permission issues with devices

If you're having issues accessing LED controllers or other hardware:

1. Make sure the container has the necessary permissions
2. Check if `privileged: true` is set in docker-compose.yml
3. Verify device paths in your system match those in the configuration

## Next Steps

- Read the full [README.md](README.md) for detailed documentation
- Check [examples/](examples/) for advanced configurations
- Join the [Hyperion.ng community](https://hyperion-project.org/forum/)

## Need Help?

- **Documentation**: https://docs.hyperion-project.org/
- **Forum**: https://hyperion-project.org/forum/
- **Issues**: https://github.com/stephenscholz/hyperion-docker/issues

## Configuration Persistence

Your configuration is stored in `./config/` directory and will persist across container restarts and updates.

To backup:
```bash
make backup
# or manually
tar -czf hyperion-backup.tar.gz config/
```

To restore:
```bash
make restore BACKUP=backups/hyperion-config-YYYYMMDD-HHMMSS.tar.gz
# or manually
tar -xzf hyperion-backup.tar.gz
```

## Updating

To update to the latest version:

```bash
# Pull latest changes
git pull

# Rebuild and restart
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

Or using the Makefile:
```bash
make update
```

Enjoy your Hyperion.ng setup! 🎨✨
