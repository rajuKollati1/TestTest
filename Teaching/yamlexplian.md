# 📄 Understanding a Kubernetes Deployment YAML

This guide breaks down a standard Kubernetes `Deployment` YAML file to make it easy for students to understand.

---

## Visual Explanation

This diagram shows what each part of the YAML file does.

<div style="transform: scale(1.2); transform-origin: top left;">

```mermaid
flowchart TD

    %% --- Main Structure ---
    YAML("📄 deployment.yaml")
    
    subgraph YAML
        A("`apiVersion: apps/v1`")
        B("`kind: Deployment`")
        C("`metadata` - Deployment name")
        D("`spec` - The Desired State")
    end

    D --&gt; D1("`replicas: 2`&lt;br&gt;I want 2 copies running")
    D --&gt; D2("`selector`&lt;br&gt;Which Pods do I manage?")
    D --&gt; D3("`template`&lt;br&gt;The blueprint for creating Pods")

    D2 --&gt; D2_1("`matchLabels`&lt;br&gt;Find Pods with `app: nginx`")
    D3 --&gt; T1("`metadata`&lt;br&gt;Labels for the Pods")
    D3 --&gt; T2("`spec`&lt;br&gt;What's inside each Pod?")

    T1 --&gt; T1_1("`labels`&lt;br&gt;`app: nginx`&lt;br&gt;MUST MATCH the selector!")
    T2 --&gt; T2_1("`containers`")
    T2_1 --&gt; T2_2("`image: nginx:1.21`&lt;br&gt;The container image to run")
    T2_1 --&gt; T2_3("`ports`&lt;br&gt;The ports the container exposes")

    %% --- Apply Styles ---
    class YAML,A,B,C,D rootStyle
    class D1,D2,D2_1 specStyle
    class D3,T1,T1_1,T2 templateStyle
    class T2_1,T2_2,T2_3 containerStyle
```

</div>

---

## Example `deployment.yaml`

Here is a simple YAML file that defines a Deployment to run two replicas of an NGINX web server, with comments explaining each line.

```yaml
# The API version for the Deployment object. 'apps/v1' is the stable version.
apiVersion: apps/v1
# The type of Kubernetes object we are creating.
kind: Deployment
# Metadata about the Deployment itself.
metadata:
  # The name of our Deployment. Must be unique within the namespace.
  name: nginx-deployment
# The specification, or "desired state," for our Deployment.
spec:
  # How many identical copies (Pods) of our application we want running.
  replicas: 2
  # How the Deployment finds the Pods it is supposed to manage.
  selector:
    # It looks for Pods with labels that match these key-value pairs.
    matchLabels:
      app: nginx
  # The blueprint for the Pods that this Deployment will create.
  template:
    # Metadata for the Pods themselves.
    metadata:
      # Labels to apply to each Pod created from this template.
      # IMPORTANT: These labels MUST match the 'spec.selector.matchLabels' above.
      labels:
        app: nginx
    # The specification for the Pods.
    spec:
      # A list of containers to run inside each Pod.
      containers:
      # The name of the container.
      - name: nginx-container
        # The Docker image to use for this container.
        image: nginx:1.21
        # A list of ports the container exposes.
        ports:
        # The port number inside the container.
        - containerPort: 80
```

---

## Visual Explanation

This diagram shows what each part of the YAML file does.

<div style="transform: scale(1.2); transform-origin: top left;">

### How to Explain This Diagram:

1.  **Top-Level Keys**: Every Kubernetes object has `apiVersion`, `kind`, and `metadata`. The `spec` is where you define what you want the object to do.

2.  **Deployment `spec` (The Brains)**:
    *   **`replicas`**: This is the simplest part. It just tells Kubernetes how many copies of your application you want running.
    *   **`selector`**: This is how the Deployment knows which Pods "belong" to it. It constantly scans the cluster for Pods with labels that match this selector.
    *   **`template`**: This is the most important part. It's a **blueprint** for creating the Pods. It has its own `metadata` (for labels) and a `spec` (for the container details).

3.  **The Golden Rule (Selector and Template Labels)**:
    *   Emphasize to your students that the `spec.template.metadata.labels` **must match** the `spec.selector.matchLabels`.
    *   This is how the Pods created by the template get the correct "tag" so that the Deployment can find and manage them. This is a very common source of errors for beginners.

4.  **Pod `spec` (The Container)**:
    *   Inside the template, the `spec` defines the actual Pod. The most important part is the `containers` list.
    *   Here you define the `image` to pull from a registry (like Docker Hub) and the `ports` your application listens on.

This combination of a real YAML file and a visual breakdown should make the concepts much easier for your students to grasp.
