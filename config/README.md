# Hyperion Configuration Directory

This directory will contain your Hyperion.ng configuration files after the first run.

## Contents

After starting Hyperion for the first time, this directory will contain:

- `hyperion.config.json` - Main configuration file
- `hyperion.db` - Database file for storing settings

## Configuration

You can configure Hyperion through:

1. **Web Interface** (Recommended)
   - Navigate to http://localhost:8090
   - Use the graphical interface to configure all settings

2. **Manual Configuration**
   - Edit `hyperion.config.json` directly
   - Restart the container for changes to take effect

## Backup

It's recommended to backup this directory regularly:

```bash
# Backup
tar -czf hyperion-config-backup-$(date +%Y%m%d).tar.gz config/

# Restore
tar -xzf hyperion-config-backup-YYYYMMDD.tar.gz
```

## Example Configuration

For a basic configuration example, visit:
https://docs.hyperion-project.org/en/user/Configuration.html

## Notes

- Configuration files are created automatically on first run
- Do not delete this directory while the container is running
- Mount this directory as a volume for persistence
