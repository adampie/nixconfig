# Docker

## Security
- Create non-root user with `RUN adduser --disabled-password --gecos '' appuser && USER appuser`
- Pin base image to specific version tags instead of `latest`

## Image Size Optimization
- Use multi-stage builds with `FROM image AS stage-name` syntax
- Create `.dockerignore` file excluding `node_modules`, `.git`, and build artifacts
- Combine RUN commands with `&&` to minimize layers
- Clean package manager caches in same RUN command using `rm -rf /var/lib/apt/lists/*` or equivalent
