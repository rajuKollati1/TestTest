# 📄 From YAML to Pods: The Kubernetes Deployment Lifecycle

This diagram explains how a `deployment.yaml` file is used by Kubernetes to create and manage your application's Pods.

<div style="transform: scale(1.2); transform-origin: top left;">

```mermaid
flowchart LR
    %% --- Style Definitions ---
    classDef userStyle fill:#e0f7fa,stroke:#00796b,stroke-width:2px,color:#333
    classDef yamlStyle fill:#f3e5f5,stroke:#6a1b9a,stroke-width:2px,color:#333
    classDef k8sStyle fill:#d4edda,stroke:#2e7d32,stroke-width:2px,color:#333
    classDef podStyle fill:#fff3e0,stroke:#ef6c00,stroke-width:2px,color:#333

    %% --- Components ---
    User("👨‍💻 You")

    subgraph YAMLFile["📄 deployment.yaml"]
        direction TB
        SpecReplicas["`spec.replicas: 3`<br>How many copies?"]
        SpecSelector["`spec.selector`<br>Which Pods to manage?"]
        SpecTemplate["`spec.template`<br>Blueprint for Pods"]
    end

    subgraph Cluster["☸️ Kubernetes Cluster"]
        direction TB
        Deployment["⚙️ Deployment Controller"]
        ReplicaSet["⚙️ ReplicaSet Controller"]
        subgraph Pods["Running Pods"]
            direction LR
            Pod1["📦 Pod 1"]
            Pod2["📦 Pod 2"]
            Pod3["📦 Pod 3"]
        end
    end

    %% --- Connections ---
    User -- "1. `kubectl apply -f`" --> YAMLFile
    YAMLFile -- "2. Creates" --> Deployment
    
    SpecReplicas -.-> Deployment
    SpecSelector -.-> Deployment
    SpecTemplate -.-> Deployment

    Deployment -- "3. Uses `template` to create" --> ReplicaSet
    ReplicaSet -- "4. Creates 3 Pods based on `replicas`" --> Pods
    Deployment -- "5. Watches Pods via `selector`" --> Pods

    %% --- Apply Styles ---
    class User userStyle
    class SpecReplicas,SpecSelector,SpecTemplate yamlStyle
    class Deployment,ReplicaSet k8sStyle
    class Pod1,Pod2,Pod3 podStyle
```

</div>

### How to Explain This Diagram:

1.  **You Apply the File**: The process starts when you, the user, run `kubectl apply` on your `deployment.yaml` file.

2.  **Deployment is Created**: Kubernetes reads the YAML and creates a `Deployment` object in the cluster. This object holds your desired state.
    *   The `spec.replicas` field tells the Deployment you want **3 copies**.
    *   The `spec.template` field gives the Deployment a **blueprint** for how to create each Pod (what container image to use, ports, etc.).
    *   The `spec.selector` field tells the Deployment how to find the Pods it's supposed to be managing.

3.  **Deployment Creates a ReplicaSet**: The Deployment's main job is to manage application versions. For managing the number of copies, it delegates the work to a `ReplicaSet` controller. It creates a new ReplicaSet based on the Pod template.

4.  **ReplicaSet Creates the Pods**: The ReplicaSet's only job is to make sure the correct number of Pods are running. It sees `replicas: 3` and creates three Pods.

5.  **Deployment Watches the Pods**: The Deployment continuously watches the Pods that match its `selector`. If a Pod crashes or is deleted, the Deployment will see it, and its ReplicaSet will create a new one to maintain the desired state of 3 replicas.

This diagram provides a clear, step-by-step visual flow that should be very helpful for your students to understand how their YAML file brings an application to life in Kubernetes.
