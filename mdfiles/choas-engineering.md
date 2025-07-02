# ✅ What Can Chaos Engineering Test?

Chaos experiments can be applied to various layers of your system:

---

## 🔹 1. Pods / Containers

- Simulate pod crash or container kill  
- Cause high CPU or memory usage  
- Inject network latency or packet loss  
- Fill the disk inside a container  

👉 **Used to test self-healing and resource auto-scaling.**

---

## 🔹 2. Nodes / VMs / Hosts

- Drain a Kubernetes node (simulate node failure)  
- Reboot a VM  
- Introduce CPU stress or memory pressure on the node  
- Detach storage or network  

👉 **Helps test node pool resilience and cluster auto-healing.**

---

## 🔹 3. Network & DNS

- Block outgoing/incoming traffic to a service  
- Add latency, jitter, or packet loss  
- Corrupt DNS resolution  
- Simulate external service being unavailable  

👉 **Useful for testing failover and service discovery.**

---

## 🔹 4. Storage & Volumes

- Simulate volume unavailability (EBS/PersistentVolume)  
- Fill up storage disk (disk pressure)  
- Inject latency in storage I/O  

👉 **Tests how apps handle I/O failures, important for databases.**

---

## 🔹 5. Application Level

- Kill the main application process inside a pod  
- Simulate exceptions or timeouts in APIs  
- Delay downstream service responses  

👉 **Helps validate retry logic, error handling, timeouts.**

---

## 🔹 6. Cloud Services (Advanced)

- Turn off a cloud service (e.g., RDS, S3, Load Balancer)  
- Revoke IAM role temporarily  
- Remove a DNS record  
