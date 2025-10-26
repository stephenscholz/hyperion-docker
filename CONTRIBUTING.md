# Contributing to Hyperion.ng Docker

Thank you for your interest in contributing to this project! This document provides guidelines for contributing.

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [Issues](https://github.com/stephenscholz/hyperion-docker/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (OS, Docker version, etc.)

### Submitting Changes

1. **Fork the repository** to your own GitHub account

2. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/hyperion-docker.git
   cd hyperion-docker
   ```

3. **Create a new branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**:
   - Follow the existing code style
   - Test your changes thoroughly
   - Update documentation if needed

5. **Test the Docker build**:
   ```bash
   docker build -t hyperion-ng:test .
   docker run -d --name hyperion-test hyperion-ng:test
   docker logs hyperion-test
   docker rm -f hyperion-test
   ```

6. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: Add your feature description"
   ```

7. **Push to your fork**:
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request** from your fork to the main repository

## Commit Message Guidelines

We follow conventional commit messages:

- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `refactor:` - Code refactoring
- `test:` - Test additions or changes

Example:
```
feat: Add support for ARM64 architecture
fix: Correct health check command
docs: Update README with troubleshooting tips
```

## Code Style

### Dockerfile

- Use multi-stage builds when possible
- Minimize the number of layers
- Order instructions from least to most frequently changing
- Use specific version tags, not `latest`
- Clean up package manager caches
- Run containers as non-root users

### Documentation

- Use clear, concise language
- Provide examples where helpful
- Keep the README.md up to date
- Add comments for complex configurations

## Testing

Before submitting a PR, ensure:

1. **Dockerfile builds successfully**:
   ```bash
   docker build --no-cache -t hyperion-ng:test .
   ```

2. **Container starts correctly**:
   ```bash
   docker run -d --name hyperion-test hyperion-ng:test
   docker ps | grep hyperion-test
   ```

3. **No security vulnerabilities** (if possible):
   ```bash
   docker scan hyperion-ng:test
   ```

4. **docker-compose works**:
   ```bash
   docker-compose up -d
   docker-compose ps
   docker-compose down
   ```

## Questions?

Feel free to open an issue with your question, or reach out to the maintainers.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
