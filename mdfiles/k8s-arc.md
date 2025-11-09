## Kubernetes Architecture Overview

This diagram illustrates the core components of a basic Kubernetes cluster, separated into the Control Plane (Master) and the Worker Nodes.

```mermaid
graph TD

    subgraph Control Plane (Master Node)
        A[API Server] -- read/write --> B(etcd: Cluster State Database)
        A -- communicates with --> C(Controller Manager)
        A -- communicates with --> D(Scheduler)
        D -- allocates Pods to --> F
    end

    subgraph Worker Node(s)
        F[Kubelet] -- creates/manages Pods --> G(Container Runtime: e.g., Docker)
        F -- watches API Server for changes --> A
        H[Kube-Proxy] -- manages network rules --> I(Services / Load Balancing)
        G -- runs --> J(Pods: Containers Group)
        H -- load balances traffic to --> J
    end

    subgraph User & External Tools
        K(kubectl / Client) -- calls API --> A
    end

    % Define the connections/flow
    A --> F
    F --> A
    K --> A
    I --> H

    % Styling (Optional but helpful for visual clarity)
    classDef master fill:#F9D7D4,stroke:#A30000,stroke-width:2px;
    class A,B,C,D master;
    classDef worker fill:#D6EAF8,stroke:#1A5276,stroke-width:2px;
    class F,G,H worker;
    classDef external fill:#EAECEE,stroke:#626567;
    class K,I external;## Kubernetes Architecture Overview

This diagram illustrates the core components of a basic Kubernetes cluster, separated into the Control Plane (Master) and the Worker Nodes.

```mermaid
graph TD

    subgraph Control Plane (Master Node)
        A[API Server] -- read/write --> B(etcd: Cluster State Database)
        A -- communicates with --> C(Controller Manager)
        A -- communicates with --> D(Scheduler)
        D -- allocates Pods to --> F
    end

    subgraph Worker Node(s)
        F[Kubelet] -- creates/manages Pods --> G(Container Runtime: e.g., Docker)
        F -- watches API Server for changes --> A
        H[Kube-Proxy] -- manages network rules --> I(Services / Load Balancing)
        G -- runs --> J(Pods: Containers Group)
        H -- load balances traffic to --> J
    end

    subgraph User & External Tools
        K(kubectl / Client) -- calls API --> A
    end

    % Define the connections/flow
    A --> F
    F --> A
    K --> A
    I --> H

    % Styling (Optional but helpful for visual clarity)
    classDef master fill:#F9D7D4,stroke:#A30000,stroke-width:2px;
    class A,B,C,D master;
    classDef worker fill:#D6EAF8,stroke:#1A5276,stroke-width:2px;
    class F,G,H worker;
    classDef external fill:#EAECEE,stroke:#626567;
    class K,I external;
