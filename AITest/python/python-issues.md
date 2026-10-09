# Python Agent Kubernetes API Troubleshooting

## Problem

When testing the Kubernetes Python client inside the Python-agent pod, the following error occurred:

```text
LocationValueError: No host specified.
```

The test was:

```python
from kubernetes import client

api = client.CoreV1Api()

pods = api.list_namespaced_pod("default")
```

The Kubernetes Python client was installed correctly, but the Kubernetes configuration had not been loaded.

---

## 1. Test the Kubernetes client correctly

Exit the Python shell:

```python
exit()
```

Start Python again:

```bash
python
```

Run these commands in this exact order:

```python
from kubernetes import client, config
```

Load the in-cluster Kubernetes configuration:

```python
config.load_incluster_config()
```

There should be no error.

Create the Kubernetes API client:

```python
api = client.CoreV1Api()
```

List pods:

```python
pods = api.list_namespaced_pod("default")
```

Check the number of pods:

```python
print(len(pods.items))
```

Print pod names and status:

```python
for pod in pods.items:
    print(pod.metadata.name, pod.status.phase)
```

### Expected result

You should see something similar to:

```text
5
python-agent-xxxxx Running
ollama-xxxxx Running
k8s-mcp-xxxxx Running
...
```

The exact number and names depend on your cluster.

---

## 2. Why the previous test failed

The previous test only did:

```python
from kubernetes import client

api = client.CoreV1Api()
```

The Python Kubernetes client does not automatically know that the application is running inside a Kubernetes pod.

You need to load the in-cluster configuration:

```python
config.load_incluster_config()
```

This allows the client to discover the Kubernetes API server and use the ServiceAccount credentials mounted into the pod.

Conceptually:

```text
Python Agent Pod
       |
       | load_incluster_config()
       v
ServiceAccount token
       |
       v
Kubernetes API
       |
       v
Pods / Nodes / Deployments
```

---

## 3. Correct `server.py` configuration

Your `server.py` should have the Kubernetes configuration before creating the API clients.

Use:

```python
from kubernetes import client, config

try:
    config.load_incluster_config()
    print("Loaded in-cluster Kubernetes configuration")
except Exception:
    config.load_kube_config()
    print("Loaded local kubeconfig")

core_api = client.CoreV1Api()
apps_api = client.AppsV1Api()
```

### Correct order

```text
Import Kubernetes library
        |
        v
Load Kubernetes configuration
        |
        v
Create CoreV1Api()
        |
        v
Call Kubernetes API
```

### Incorrect order

```text
Import Kubernetes library
        |
        v
Create CoreV1Api()
        |
        v
Try to load configuration later
```

---

## 4. Test RBAC separately

After loading the configuration:

```python
from kubernetes import client, config

config.load_incluster_config()

api = client.CoreV1Api()

pods = api.list_namespaced_pod("default")
```

If this returns:

```text
403 Forbidden
```

then the Python agent can reach the Kubernetes API, but the ServiceAccount does not have sufficient permissions.

If pod names are returned, then:

```text
Python
  |
  v
Kubernetes API
  |
  v
RBAC
  |
  v
SUCCESS
```

---

## 5. Test Kubernetes nodes

Once pod access works:

```python
nodes = api.list_node()
```

Then:

```python
for node in nodes.items:
    print(node.metadata.name)
```

You should see your Kubernetes nodes, for example:

```text
k8s-master
k8s-worker-node01
k8s-worker-node02
```

The actual names depend on your lab.

---

## 6. Check Kubernetes environment variables

From the Linux shell inside the Python-agent container, run:

```bash
env | grep KUBERNETES
```

You should see variables similar to:

```text
KUBERNETES_SERVICE_HOST=10.x.x.x
KUBERNETES_SERVICE_PORT=443
```

These variables are provided to pods so applications can discover the Kubernetes API service.

---

## 7. Check ServiceAccount credentials

From the Linux shell, run:

```bash
ls -l /var/run/secrets/kubernetes.io/serviceaccount/
```

You should see files similar to:

```text
ca.crt
namespace
token
```

These are the credentials and metadata used by the Kubernetes client when running inside the cluster.

---

## 8. Important conclusion

The error:

```text
LocationValueError: No host specified.
```

is not an Ollama problem.

It is not an MCP problem.

It is not necessarily an RBAC problem.

The immediate issue is that the manual Python test did not load the in-cluster Kubernetes configuration.

The correct test is:

```python
from kubernetes import client, config

config.load_incluster_config()

api = client.CoreV1Api()

pods = api.list_namespaced_pod("default")

print(len(pods.items))

for pod in pods.items:
    print(pod.metadata.name, pod.status.phase)
```

If this works, the next layer to test is:

```text
Python Agent
     |
     v
Kubernetes API
     |
     v
MCP
     |
     v
Goose
```

Ollama is a separate component responsible for the LLM/model generation.

---

## 9. Recommended architecture

For the AI lab:

```text
                         Windows Laptop
                              |
                              |
                            Goose
                              |
                              | MCP
                              v
                    +-------------------+
                    |     k8s-mcp       |
                    |     NodePort      |
                    |      :30800       |
                    +---------+---------+
                              |
                              | HTTP
                              v
                    +-------------------+
                    |   python-agent    |
                    |                   |
                    |    server.py      |
                    |       :8000       |
                    +---------+---------+
                              |
                    +---------+---------+
                    |                   |
                    v                   v
             Kubernetes API          Ollama
                    |                 :11434
             ServiceAccount             |
             ai-k8s-agent               v
                    |              Qwen2.5 1.5B
                    v
              K8s resources
```

### Important distinction

Ollama does not need to access the Kubernetes API.

The Python agent can communicate with:

```text
Python Agent
    |
    +---- Kubernetes API
    |
    +---- Ollama
```

Ollama is responsible for running the LLM and generating responses.

---

## 10. Next troubleshooting commands

Run these commands from your Kubernetes environment:

```bash
kubectl get pods -o wide
```

```bash
kubectl logs deployment/python-agent --tail=100
```

```bash
kubectl describe pod -l app=python-agent
```

```bash
kubectl get deployment python-agent -o yaml
```

```bash
kubectl get svc python-agent k8s-mcp
```

The most important output is:

```bash
kubectl logs deployment/python-agent --tail=100
```

This can identify whether the remaining problem is related to:

- Python/MCP code
- Docker image
- ConfigMap/PVC mounting
- ServiceAccount
- RBAC
- Kubernetes Service
- MCP connection
