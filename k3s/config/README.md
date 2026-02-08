# K3s Configuration

## Structure

```
systemd/       → Systemd units (CNI tmpfs mount)
manifests/     → Kubernetes manifests to apply after k3s starts
```

## Post-boot Setup

After booting the k3s image:

```bash
# Deploy config (systemd units)
sudo cp config/systemd/* /etc/systemd/system/
sudo systemctl daemon-reload

# Enable CNI mount (required - makes /opt/cni/bin writable for Cilium)
sudo systemctl enable --now opt-cni-bin.mount

# Start k3s
sudo systemctl enable --now k3s

# Copy kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

# Install Cilium CNI (required - k3s has no default CNI)
cilium install

# Verify
cilium status
kubectl get nodes
```

## Applying Manifests

```bash
kubectl apply -f manifests/
```
