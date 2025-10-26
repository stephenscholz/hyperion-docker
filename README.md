# Hyperion.ng Docker

A modern, optimized Docker container for [Hyperion.ng](https://github.com/hyperion-project/hyperion.ng) - Open Source Ambient Lighting Software.

[![Docker Build](https://img.shields.io/badge/docker-build-blue.svg)](https://github.com/stephenscholz/hyperion-docker)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

## Features

- 🚀 **Modern Multi-Stage Build** - Optimized for minimal image size
- 🔒 **Security First** - Runs as non-root user
- 🏗️ **Latest Debian Base** - Built on Debian Bookworm Slim
- 🎯 **Easy Configuration** - Simple volume mounts for config persistence
- 📊 **Health Checks** - Built-in container health monitoring
- 🔧 **Flexible Deployment** - Supports docker-compose and standalone Docker
- 🌐 **Multi-Architecture Ready** - Can be built for amd64, arm64, armhf

## Quick Start

### Using Docker Compose (Recommended)

1. Clone this repository:
```bash
git clone https://github.com/stephenscholz/hyperion-docker.git
cd hyperion-docker
```

2. Create a config directory:
```bash
mkdir -p config
```

3. Start Hyperion:
```bash
docker-compose up -d
```

4. Access the web interface at http://localhost:8090

### Using Docker CLI

```bash
# Build the image
docker build -t hyperion-ng:latest .

# Run the container
docker run -d \
  --name hyperion \
  --network host \
  --privileged \
  -v $(pwd)/config:/opt/hyperion/config \
  -v /dev:/dev \
  -e TZ=Europe/London \
  hyperion-ng:latest
```

## Configuration

### Ports

| Port  | Protocol | Description        |
|-------|----------|--------------------|
| 8090  | HTTP     | Web UI             |
| 19444 | TCP      | JSON Server        |
| 19445 | TCP      | Protobuf Server    |
| 19400 | TCP      | Flatbuffer Server  |
| 2100  | TCP      | Boblight Server    |

### Volumes

- `/opt/hyperion/config` - Configuration files and database

### Environment Variables

| Variable            | Default | Description                    |
|---------------------|---------|--------------------------------|
| HYPERION_HTTP_PORT  | 8090    | Web interface port             |
| HYPERION_JSON_PORT  | 19444   | JSON API port                  |
| TZ                  | -       | Timezone (e.g., Europe/London) |

## Building from Source

### Build Arguments

- `HYPERION_VERSION` - Git branch or tag to build from (default: `master`)

Example:
```bash
docker build --build-arg HYPERION_VERSION=2.0.16 -t hyperion-ng:2.0.16 .
```

### Multi-Architecture Build

To build for multiple architectures (requires Docker Buildx):

```bash
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 \
  -t hyperion-ng:latest \
  --push .
```

## Hardware Access

### LED Controllers

For LED controllers, you may need to:

1. **Use privileged mode** (docker-compose.yml default):
```yaml
privileged: true
```

2. **Or grant specific device access**:
```yaml
devices:
  - /dev/spidev0.0:/dev/spidev0.0
  - /dev/ttyUSB0:/dev/ttyUSB0
```

### Video Capture

For screen capture from video devices:
```yaml
devices:
  - /dev/video0:/dev/video0
```

## Advanced Usage

### Custom Configuration

Mount your own configuration file:
```bash
docker run -d \
  --name hyperion \
  -v /path/to/your/hyperion.config.json:/opt/hyperion/config/hyperion.config.json \
  -p 8090:8090 \
  hyperion-ng:latest
```

### Running with Specific Options

Pass additional arguments to hyperiond:
```bash
docker run -d \
  --name hyperion \
  -v $(pwd)/config:/opt/hyperion/config \
  hyperion-ng:latest \
  --userdata /opt/hyperion/config \
  --debug
```

### Network Mode

#### Host Network (Recommended for LED discovery)
```yaml
network_mode: host
```

#### Bridge Network
```yaml
ports:
  - "8090:8090"
  - "19444:19444"
```

## Troubleshooting

### Container won't start

Check logs:
```bash
docker logs hyperion
```

### Permission Issues

If you encounter permission issues with devices:
1. Ensure the container runs in privileged mode, or
2. Add the hyperion user to the appropriate groups on the host
3. Check device permissions on the host

### Configuration Not Persisting

Ensure the config volume is properly mounted:
```bash
docker inspect hyperion | grep -A 10 Mounts
```

### Web Interface Not Accessible

1. Check if the container is running:
```bash
docker ps | grep hyperion
```

2. Verify port mapping:
```bash
docker port hyperion
```

3. Check firewall rules on your host

### Health Check Failing

The health check runs `hyperiond --test`. If it fails:
1. Check if Hyperion is properly installed in the container
2. Review build logs for errors
3. Ensure all dependencies are installed

## Development

### Building a Development Version

To build from a specific branch:
```bash
docker build \
  --build-arg HYPERION_VERSION=development \
  -t hyperion-ng:dev \
  .
```

### Debugging

Run the container interactively:
```bash
docker run -it --rm \
  --entrypoint /bin/bash \
  hyperion-ng:latest
```

## Security Considerations

- The container runs as a non-root user (`hyperion`)
- Privileged mode is only required for hardware access
- Consider using specific device access instead of privileged mode when possible
- Keep the image updated to receive security patches

## Performance Tips

1. **Use host network mode** for better performance with LED protocols
2. **Limit log size** to prevent disk space issues
3. **Use specific Hyperion version tags** for production deployments
4. **Monitor container resources** with `docker stats hyperion`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Hyperion.ng Project](https://github.com/hyperion-project/hyperion.ng) - The amazing ambient lighting software
- Docker community for best practices and inspiration

## Support

- **Hyperion.ng Documentation**: https://docs.hyperion-project.org/
- **Hyperion.ng Forum**: https://hyperion-project.org/forum/
- **Issues**: https://github.com/stephenscholz/hyperion-docker/issues

## Changelog

### Latest
- Initial release with modern multi-stage Dockerfile
- Added docker-compose support
- Comprehensive documentation
- Security hardening with non-root user
- Health checks and logging configuration