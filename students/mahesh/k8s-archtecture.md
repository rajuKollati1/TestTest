
---

## ⚙️ Components of Kubernetes

### 🧩 1. Control Plane (Master Node)

This is the **brain** of Kubernetes — it controls and manages the cluster.

#### a. **API Server**
- Acts as the **entry point** to the cluster.
- All commands from `kubectl` or dashboards go through the API server.
- Validates and processes REST requests.

#### b. **etcd**
- A **key-value store** that stores all cluster data (like configuration, secrets, state).
- Acts as the **single source of truth** for the cluster.

#### c. **Controller Manager**
- Monitors cluster state.
- Ensures desired state = actual state.
- Common controllers:
  - Node Controller
  - Replication Controller
  - Endpoints Controller

#### d. **Scheduler**
- Assigns pods to available nodes.
- Considers CPU, memory, affinity, taints, and node health.

---

### 🖥️ 2. Worker Node (Node Plane)

This is where the **actual workload runs** (Pods and Containers).

#### a. **Kubelet**
- The **node agent** that communicates with the API server.
- Ensures pods are running correctly on the node.

#### b. **Kube Proxy**
- Handles **network communication** between pods and services.
- Manages load balancing and routing inside the cluster.

#### c. **Container Runtime**
- The engine that runs containers.
- Examples:
  - Docker
  - containerd
  - CRI-O

---

## 🧱 Core Kubernetes Objects

| Object | Description |
|---------|--------------|
| **Pod** | Smallest deployable unit in K8s; encapsulates one or more containers |
| **Service** | Provides stable networking and load balancing to Pods |
| **Deployment** | Manages desired number of identical Pods (replicas) |
| **ReplicaSet** | Ensures specific number of pod replicas are running |
| **ConfigMap** | Stores non-confidential configuration data |
| **Secret** | Stores sensitive data like passwords or tokens |

---

## 🔄 Kubernetes Workflow

1. **User Interaction**
   - You run a command:  
     ```bash
     kubectl apply -f deployment.yaml
     ```

2. **API Server Receives Request**
   - Validates it and stores it in `etcd`.

3. **Scheduler**
   - Picks the best node for the new Pod.

4. **Kubelet**
   - Runs the container using the Container Runtime.

5. **Kube Proxy**
   - Ensures the Pod is reachable via Service networking.

---
⚙️ Control Plane Components
| Component              | Symbol | Description                                    |
| ---------------------- | ------ | ---------------------------------------------- |
| **API Server**         | 🌐     | Entry point for all commands; exposes REST API |
| **etcd**               | 🧩     | Key-value store holding cluster state          |
| **Controller Manager** | 🕹️    | Ensures cluster state matches desired state    |
| **Scheduler**          | 📅     | Decides which node runs which pod              |

🖥️ Worker Node Components
| Component             | Symbol | Description                                       |
| --------------------- | ------ | ------------------------------------------------- |
| **Kubelet**           | 🤖     | Talks to API server; manages pods on node         |
| **Kube Proxy**        | 🔀     | Manages network rules for pods & services         |
| **Container Runtime** | 🐳     | Runs containers (Docker, containerd, CRI-O)       |
| **Pods**              | 🧫     | Smallest deployable unit (one or more containers) |




