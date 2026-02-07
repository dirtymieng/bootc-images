#!/bin/bash
# Build all bootc images in order
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${SCRIPT_DIR}/.."
REGISTRY="${REGISTRY:-ghcr.io/dirtymieng}"

# Build base first
echo "=== Building base ==="
podman build -t bootc-base:latest "${REPO_ROOT}/base"
podman tag bootc-base:latest "${REGISTRY}/bootc-base:latest"

if [ "${PUSH:-false}" = "true" ]; then
    podman push "${REGISTRY}/bootc-base:latest"
fi

# Build variants
for variant in server k3s gaming; do
    if [ -f "${REPO_ROOT}/${variant}/Containerfile" ]; then
        echo "=== Building ${variant} ==="
        podman build -t "bootc-${variant}:latest" "${REPO_ROOT}/${variant}"
        podman tag "bootc-${variant}:latest" "${REGISTRY}/bootc-${variant}:latest"

        if [ "${PUSH:-false}" = "true" ]; then
            podman push "${REGISTRY}/bootc-${variant}:latest"
        fi
    fi
done

echo ""
echo "Build complete!"
echo ""
echo "To push all images:"
echo "  PUSH=true ./scripts/build-all.sh"
