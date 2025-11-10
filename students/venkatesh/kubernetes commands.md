# ☸️ Kubernetes (K8s) Commands Cheat Sheet — Full Guide

This file contains **complete Kubernetes commands** with **detailed explanations**, examples, and usage syntax.

---

## ⚙️ 1. Cluster Information

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl version` | Shows Kubernetes client and server version. | `kubectl version --short` |
| `kubectl cluster-info` | Displays the master and service endpoints. | `kubectl cluster-info` |
| `kubectl get nodes` | Lists all nodes in the cluster. | `kubectl get nodes -o wide` |
| `kubectl describe node <node-name>` | Shows detailed info about a specific node. | `kubectl describe node worker-1` |
| `kubectl top nodes` | Displays CPU and memory usage of nodes (requires metrics-server). | `kubectl top nodes` |

---

## 📦 2. Pod Management

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl get pods` | Lists all pods in current namespace. | `kubectl get pods -o wide` |
| `kubectl get pods -A` | Lists pods across all namespaces. | `kubectl get pods -A` |
| `kubectl describe pod <pod-name>` | Shows detailed info of a specific pod. | `kubectl describe pod nginx-abc123` |
| `kubectl logs <pod-name>` | Displays pod logs. | `kubectl logs nginx-pod` |
| `kubectl logs -f <pod-name>` | Streams live pod logs (follow mode). | `kubectl logs -f nginx-pod` |
| `kubectl exec -it <pod-name> -- bash` | Access pod shell (interactive terminal). | `kubectl exec -it nginx-pod -- sh` |
| `kubectl delete pod <pod-name>` | Deletes a specific pod. | `kubectl delete pod nginx-pod` |
| `kubectl run <name> --image=<image>` | Creates a new pod from image. | `kubectl run nginx --image=nginx:latest` |

---

## 🧩 3. Deployments

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl get deployments` | Lists all deployments. | `kubectl get deployments -o wide` |
| `kubectl describe deployment <name>` | Shows detailed info of deployment. | `kubectl describe deployment nginx-deploy` |
| `kubectl create deployment <name> --image=<image>` | Creates a new deployment. | `kubectl create deployment myapp --image=nginx` |
| `kubectl scale deployment <name> --replicas=<n>` | Scales the deployment to given replicas. | `kubectl scale deployment myapp --replicas=3` |
| `kubectl edit deployment <name>` | Opens deployment for manual editing. | `kubectl edit deployment myapp` |
| `kubectl delete deployment <name>` | Deletes deployment. | `kubectl delete deployment myapp` |
| `kubectl rollout status deployment/<name>` | Monitors rollout status. | `kubectl rollout status deployment/myapp` |
| `kubectl rollout history deployment/<name>` | Shows rollout history. | `kubectl rollout history deployment/myapp` |
| `kubectl rollout undo deployment/<name>` | Reverts to previous version. | `kubectl rollout undo deployment/myapp` |

---

## 🏗️ 4. Services (Networking)

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl get svc` | Lists all services. | `kubectl get svc -o wide` |
| `kubectl describe svc <service-name>` | Shows details of a service. | `kubectl describe svc my-service` |
| `kubectl expose deployment <name> --port=<p> --type=<type>` | Creates a service from deployment. | `kubectl expose deployment myapp --port=80 --type=NodePort` |
| `kubectl delete svc <service-name>` | Deletes service. | `kubectl delete svc my-service` |

---

## 🧱 5. Namespaces

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl get ns` | Lists namespaces. | `kubectl get ns` |
| `kubectl create ns <namespace>` | Creates a new namespace. | `kubectl create ns dev` |
| `kubectl delete ns <namespace>` | Deletes a namespace. | `kubectl delete ns test` |
| `kubectl config set-context --current --namespace=<ns>` | Sets default namespace for session. | `kubectl config set-context --current --namespace=dev` |

---

## 📜 6. Working with YAML Manifests

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl apply -f <file.yaml>` | Applies YAML configuration. | `kubectl apply -f deploy.yaml` |
| `kubectl delete -f <file.yaml>` | Deletes resources from YAML. | `kubectl delete -f pod.yaml` |
| `kubectl get -f <file.yaml>` | Displays resource info from YAML. | `kubectl get -f deploy.yaml` |
| `kubectl diff -f <file.yaml>` | Compares local YAML vs cluster. | `kubectl diff -f service.yaml` |

---

## 🧮 7. ReplicaSets, StatefulSets, DaemonSets

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl get rs` | Lists ReplicaSets. | `kubectl get rs` |
| `kubectl describe rs <name>` | Describes ReplicaSet details. | `kubectl describe rs myapp-rs` |
| `kubectl get statefulsets` | Lists StatefulSets. | `kubectl get statefulsets` |
| `kubectl describe statefulset <name>` | Describes a StatefulSet. | `kubectl describe statefulset mysql` |
| `kubectl get daemonsets` | Lists DaemonSets. | `kubectl get daemonsets -A` |

---

## 🧾 8. ConfigMaps and Secrets

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl create configmap <name> --from-literal=<key>=<val>` | Creates ConfigMap from literal. | `kubectl create configmap app-config --from-literal=ENV=prod` |
| `kubectl get configmaps` | Lists all ConfigMaps. | `kubectl get configmaps` |
| `kubectl describe configmap <name>` | Describes a ConfigMap. | `kubectl describe configmap app-config` |
| `kubectl create secret generic <name> --from-literal=<key>=<val>` | Creates Secret. | `kubectl create secret generic db-secret --from-literal=PASSWORD=1234` |
| `kubectl get secrets` | Lists Secrets. | `kubectl get secrets` |
| `kubectl describe secret <name>` | Describes Secret details. | `kubectl describe secret db-secret` |

---

## 📊 9. Monitoring & Metrics

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl top nodes` | Shows node resource usage. | `kubectl top nodes` |
| `kubectl top pods` | Shows pod resource usage. | `kubectl top pods -A` |
| `kubectl get events` | Lists cluster events. | `kubectl get events --sort-by=.metadata.creationTimestamp` |

---

## 🧹 10. Maintenance and Cleanup

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl delete all --all` | Deletes all resources in current namespace. | `kubectl delete all --all` |
| `kubectl delete pods --all` | Deletes all pods. | `kubectl delete pods --all` |
| `kubectl drain <node>` | Safely evicts pods from a node. | `kubectl drain node-1 --ignore-daemonsets` |
| `kubectl uncordon <node>` | Re-enable scheduling on node. | `kubectl uncordon node-1` |

---

## 🧭 11. Contexts and Configuration

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl config view` | Displays kubeconfig details. | `kubectl config view` |
| `kubectl config get-contexts` | Lists contexts. | `kubectl config get-contexts` |
| `kubectl config use-context <context>` | Switches context. | `kubectl config use-context minikube` |
| `kubectl config current-context` | Shows current context. | `kubectl config current-context` |

---

## 🧪 12. Debugging and Troubleshooting

| Command | Description | Example |
|----------|--------------|----------|
| `kubectl describe <resource> <name>` | Shows detailed info for debugging. | `kubectl describe pod nginx` |
| `kubectl get events` | Shows events (warnings, errors). | `kubectl get events` |
| `kubectl exec -it <pod> -- bash` | Opens terminal inside pod. | `kubectl exec -it mypod -- bash` |
| `kubectl port-forward <pod> 8080:80` | Forward pod port to localhost. | `kubectl port-forward nginx 8080:80` |

---

## 💡 13. Common Shortcuts

| Shortcut | Description |
|-----------|--------------|
| `kubectl get all` | Shows all resources (pods, svc, deployments). |
| `kubectl api-resources` | Lists all API resources supported. |
| `kubectl explain <resource>` | Describes resource fields (useful for YAML help). |
| `kubectl get pods -o wide` | Extended pod info (IP, Node). |
| `kubectl get pods --sort-by=.metadata.name` | Sort output. |

---

## 🧭 Example Deployment Workflow

```bash
# 1. Create Deployment
kubectl create deployment nginx --image=nginx

# 2. Expose it via a Service
kubectl expose deployment nginx --port=80 --type=NodePort

# 3. View resources
kubectl get all

# 4. Scale up
kubectl scale deployment nginx --replicas=3

# 5. Apply changes using YAML
kubectl apply -f deployment.yaml

# 6. Check rollout and logs
kubectl rollout status deployment/nginx
kubectl logs -f <nginx-pod-name>
