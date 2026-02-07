# CLAUDE.md

Layered bootc images for personal infrastructure.

## Structure

```
base/      → Common packages, user setup
server/    → FROM base, NAS/server (mergerfs, samba, containers)
k3s/       → FROM base, lightweight Kubernetes
gaming/    → FROM base, KDE desktop + Steam/gaming
```

## Build

```bash
# Build all locally
./scripts/build-all.sh

# Build and push to registry
PUSH=true ./scripts/build-all.sh

# Build single image
podman build -t bootc-server:latest server/
```

## Images

- `ghcr.io/dirtymieng/bootc-base` - Base image
- `ghcr.io/dirtymieng/bootc-server` - NAS/server
- `ghcr.io/dirtymieng/bootc-k3s` - Kubernetes
- `ghcr.io/dirtymieng/bootc-gaming` - Gaming desktop

## Updating

1. Modify Containerfile
2. Rebuild: `./scripts/build-all.sh`
3. Push: `PUSH=true ./scripts/build-all.sh`
4. On target: `sudo bootc upgrade`
