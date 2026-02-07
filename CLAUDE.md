# CLAUDE.md

Layered bootc images for personal infrastructure.

## Structure

```
base/                    → Common packages, user setup
server/
  Containerfile          → FROM base, NAS/server packages
  config/                → Quadlets, systemd units, samba, etc.
  deploy-config.sh       → Deploy config to /etc
k3s/
  Containerfile          → FROM base, k3s + Cilium CLI
  config/                → K8s manifests
gaming/
  Containerfile          → FROM base, KDE + Steam/gaming
  config/                → Gaming configs
scripts/
  build-all.sh           → Build all images
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

**Image changes (packages):**
1. Modify Containerfile
2. Rebuild: `./scripts/build-all.sh`
3. Push: `PUSH=true ./scripts/build-all.sh`
4. On target: `sudo bootc upgrade && reboot`

**Config changes:**
1. Modify files in `<variant>/config/`
2. On target: `git pull && sudo ./deploy-config.sh`
3. Restart affected services
