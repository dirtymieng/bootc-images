# K3s Configuration

## Structure

```
manifests/     → Kubernetes manifests to apply after k3s starts
```

## Post-boot Setup

After booting the k3s image:

```bash
# Start k3s
sudo systemctl enable --now k3s

# Copy kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Install Cilium CNI (required - k3s has no default CNI)
# These paths are required for bootc's read-only /opt
cilium install \
  --set cni.binPath=/var/lib/rancher/k3s/data/current/bin \
  --set cni.confFileMountPath=/var/lib/rancher/k3s/agent/etc/cni/net.d \
  --set cni.hostConfDirMountPath=/var/lib/rancher/k3s/agent/etc/cni/net.d

# Verify
cilium status
kubectl get nodes
```

## Applying Manifests

```bash
kubectl apply -f manifests/
```
