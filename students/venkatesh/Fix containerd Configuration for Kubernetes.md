Fix containerd Configuration for Kubernetes

This document provides step-by-step instructions to fix common kubelet startup issues
by properly configuring containerd for Kubernetes.

Prerequisites:
- Linux system with containerd installed
- Kubernetes (kubeadm / kubelet)
- sudo/root access

Step 1: Backup Existing containerd Configuration
Command:
sudo mv /etc/containerd/config.toml /etc/containerd/config.toml.bak
Step 2: Generate Fresh Default containerd Config
Command:
containerd config default | sudo tee /etc/containerd/config.toml
Step 3: Enable SystemdCgroup (Critical)
Command:
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml
Verify:
grep SystemdCgroup /etc/containerd/config.toml
Step 4: Restart containerd
Command:
sudo systemctl restart containerd
Step 5: Verify containerd Status
Command:
sudo systemctl status containerd
Step 6: Restart kubelet
Command:
sudo systemctl restart kubelet
Troubleshooting
If kubelet fails, check logs:
journalctl -xeu kubelet
Summary

- Fresh containerd configuration applied
- SystemdCgroup enabled
- containerd and kubelet restarted
- Kubernetes runtime stabilized

