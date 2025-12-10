# 🚫 Kubernetes Taints & Tolerations

This diagram explains how **Taints** on Nodes repel Pods and how **Tolerations** on Pods allow them to be scheduled on those specific Nodes.

<div style="transform: scale(1.2); transform-origin: top left;">

```mermaid
flowchart TB
    %% --- Style Definitions ---
    classDef clusterStyle fill:#d4edda,stroke:#2e7d32,stroke-width:2px,color:#333
    classDef nodeStyle fill:#fff3e0,stroke:#ef6c00,stroke-width:2px,color:#333
    classDef taintStyle fill:#f8d7da,stroke:#721c24,stroke-width:2px,color:#333
    classDef podStyle fill:#cde4ff,stroke:#1565c0,stroke-width:2px,color:#333
    classDef tolerationStyle fill:#d4edda,stroke:#2e7d32,stroke-width:1px,color:#333
    classDef noScheduleStyle fill:#f8d7da,stroke:#dc3545,stroke-width:2px,color:#333,font-weight:bold

    %% --- Components ---
    subgraph K8sCluster["☸️ Kubernetes Cluster"]
        direction TB

        subgraph NodeGroup["Worker Nodes"]
            NodeA["🖥️ Node A<br>Has Taint: `app=gpu:NoSchedule`"]
        end

        PodGood["📦 Pod with Toleration<br>(tolerates `app=gpu:NoSchedule`)"]
        PodBad["📦 Pod WITHOUT Toleration"]

        %% --- Connections ---
        PodGood -- "Can be scheduled on" --&gt; NodeA
        PodBad -- "❌ Cannot be scheduled on" --&gt; NodeA
    end

```

</div>

### How to Explain This Diagram:

1.  **The Taint (on the Node)**:
    *   A **Taint** is a property you set on a Node. It essentially says, "This node has a special characteristic, and I don't want just any Pod to run here."
    *   The example `key=value:NoSchedule` means that any Pod that *doesn't* explicitly tolerate this taint will *not* be scheduled on `Node A`.

2.  **The Toleration (on the Pod)**:
    *   A **Toleration** is a property you set on a Pod. It says, "I am okay with running on a node that has a specific taint."
    *   The `Pod with Toleration` has a matching toleration for `key=value:NoSchedule`, so it *can* be scheduled on `Node A`.
    *   The `Pod WITHOUT Toleration` does not have a matching toleration, so it will be "repelled" and cannot be scheduled on `Node A`.

3.  **Why Use Taints & Tolerations?**
    *   **Dedicated Nodes**: Reserve specific nodes for specific teams or applications (e.g., "dev-team-only").
    *   **Special Hardware**: Ensure Pods requiring GPUs or high-memory nodes only run on those nodes.
    *   **Eviction**: With the `NoExecute` effect, Pods without a matching toleration can be *evicted* from a node if it becomes tainted (e.g., due to maintenance).

### How to Set Taints and Tolerations:

**1. Setting a Taint on a Node:**

```bash
kubectl taint nodes <node-name> key=value:NoSchedule
# Example: kubectl taint nodes worker-node-1 dedicated=finance:NoSchedule
```

**2. Setting a Toleration on a Pod (in YAML):**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-finance-app
spec:
  containers:
  - name: app-container
    image: my-finance-image
  tolerations:
  - key: "dedicated"
    operator: "Equal"
    value: "finance"
    effect: "NoSchedule"
```