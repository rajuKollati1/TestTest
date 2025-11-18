# 🛠️ Containerd Configuration Fix for Kubernetes

If Kubernetes components (kubelet, API server, scheduler, etc.) cannot
communicate with containerd, the root cause is usually:

✔ Missing or broken `config.toml`\
✔ `SystemdCgroup = false` (Kubernetes needs **true**)\
✔ Missing containerd socket\
✔ CRI not working (`crictl info` fails)

------------------------------------------------------------------------

## ✅ Step 1: Go to the containerd directory

``` bash
cd /etc/containerd/
```

------------------------------------------------------------------------

## ✅ Step 2: Generate a fresh containerd config

``` bash
sudo containerd config default | sudo tee /etc/containerd/config.toml
```

------------------------------------------------------------------------

## ✅ Step 3: Edit containerd config

Open the file:

``` bash
sudo vi /etc/containerd/config.toml
```

Find:

``` toml
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
  SystemdCgroup = false
```

Change to:

``` toml
SystemdCgroup = true
```

------------------------------------------------------------------------

## ✅ Step 4: Restart services

``` bash
sudo systemctl daemon-reload
sudo systemctl restart containerd
sudo systemctl restart kubelet
```

------------------------------------------------------------------------

## ✅ Step 5: Verify containerd & kubelet communication

### 1. Check containerd

``` bash
systemctl status containerd
```

### 2. Confirm containerd socket

``` bash
ls -l /run/containerd/containerd.sock
```

### 3. Watch kubelet logs

``` bash
journalctl -u kubelet -f
```

### 4. Test CRI

``` bash
crictl ps
crictl info
```

If `crictl info` fails → containerd is still not responding.
