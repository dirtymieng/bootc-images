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
cilium install

# Verify
cilium status
kubectl get nodes
```

## Applying Manifests

```bash
kubectl apply -f manifests/
```
