## Kubernetes Architecture - Core Components

```mermaid
graph TD
    subgraph Control Plane
        A[API Server]
        B[etcd]
        C[Controller Manager]
        D[Scheduler]
    end

    subgraph Worker Nodes
        F[Kubelet]
        G[Container Runtime]
        H[Kube-Proxy]
        J[Pods]
    end

    subgraph User
        K[kubectl]
    end

    % Connections
    K --> A
    A <--> B
    A --> C
    A --> D
    D --> F
    A <--> F
    F --> G
    G --> J
    H --> J
