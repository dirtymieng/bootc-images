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

# Install Cilium CNI with Gateway API and LB IPAM
cilium install \
  --set kubeProxyReplacement=true \
  --set gatewayAPI.enabled=true \
  --set l2announcements.enabled=true \
  --set externalIPs.enabled=true

# Verify
cilium status
kubectl get nodes

# Apply manifests (LB IP pool, L2 announcements, etc.)
# Edit manifests/cilium-lb-ipam.yaml to set your IP range first!
kubectl apply -f manifests/
```
