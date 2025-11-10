# Kubernetes Commands — Basic to Advanced (with Explanations)

This Markdown file provides a **complete list of commonly used `kubectl` and Helm commands**, organized by category. Each section includes the **use/purpose** of the command, followed by the **exact syntax** and **additional notes** for better understanding.

---

## 🧭 1. Basic Commands

**Use:** Manage Kubernetes configuration, view cluster info, and switch contexts.

```bash
kubectl config view
```

> 🔹 View current Kubernetes configuration including clusters, contexts, and users.

```bash
kubectl cluster-info
```

> 🔹 Display the master and services info for the cluster.

```bash
kubectl get all
```

> 🔹 Get all resources (pods, services, deployments, etc.) in the current namespace.

```bash
kubectl get namespaces
```

> 🔹 List all namespaces available in the cluster.

```bash
kubectl config use-context <context-name>
```

> 🔹 Switch between different Kubernetes cluster contexts.

---

## 🚀 2. Working with Pods

**Use:** Manage and inspect running pods.

```bash
kubectl get pods
```

> 🔹 List all pods in the current namespace.

```bash
kubectl describe pod <pod-name>
```

> 🔹 Display detailed information (events, container status, etc.) about a specific pod.

```bash
kubectl logs <pod-name>
```

> 🔹 View logs for a given pod (helpful for debugging).

```bash
kubectl exec -it <pod-name> -- <command>
```

> 🔹 Run commands interactively inside a container (e.g., `/bin/bash`).

```bash
kubectl delete pod <pod-name>
```

> 🔹 Delete a pod (it will restart automatically if part of a Deployment).

```bash
kubectl run <pod-name> --image=<image-name>
```

> 🔹 Quickly create a pod with the specified image.

---

## ⚙️ 3. Working with Deployments

**Use:** Manage application deployments.

```bash
kubectl get deployments
```

> 🔹 List all deployments.

```bash
kubectl describe deployment <deployment-name>
```

> 🔹 Get detailed info about a deployment including replicas, events, and strategy.

```bash
kubectl apply -f <deployment-file.yaml>
```

> 🔹 Create or update resources from a YAML manifest.

```bash
kubectl delete deployment <deployment-name>
```

> 🔹 Delete a deployment.

```bash
kubectl scale deployment <deployment-name> --replicas=<number>
```

> 🔹 Scale the number of replicas (pods) for a deployment.

```bash
kubectl rollout status deployment <deployment-name>
```

> 🔹 Check the status of an ongoing rollout.

```bash
kubectl rollout history deployment <deployment-name>
```

> 🔹 View previous deployment revisions.

```bash
kubectl rollout undo deployment <deployment-name>
```

> 🔹 Roll back to a previous version of the deployment.

```bash
kubectl set image deployment/<deployment-name> <container-name>=<image>
```

> 🔹 Update the container image for a running deployment.

---

## 🧱 4. StatefulSets

**Use:** Manage stateful applications (like databases).

```bash
kubectl get statefulsets
```

> 🔹 List all StatefulSets.

```bash
kubectl describe statefulset <statefulset-name>
```

> 🔹 Get details about a StatefulSet.

```bash
kubectl delete statefulset <statefulset-name>
```

> 🔹 Delete a StatefulSet.

```bash
kubectl scale statefulset <statefulset-name> --replicas=<number>
```

> 🔹 Scale StatefulSet replicas.

---

## 🧩 5. DaemonSets

**Use:** Ensure a pod runs on all (or selected) nodes.

```bash
kubectl get daemonsets
```

> 🔹 List all DaemonSets.

```bash
kubectl describe daemonset <daemonset-name>
```

> 🔹 Describe a specific DaemonSet.

```bash
kubectl delete daemonset <daemonset-name>
```

> 🔹 Delete a DaemonSet.

---

## ⏱ 6. Jobs and CronJobs

**Use:** Manage short-lived or scheduled workloads.

```bash
kubectl get jobs
```

> 🔹 List all running or completed jobs.

```bash
kubectl describe job <job-name>
```

> 🔹 Get job details and pod completion status.

```bash
kubectl delete job <job-name>
```

> 🔹 Delete a completed or failed job.

```bash
kubectl get cronjobs
```

> 🔹 List all CronJobs.

```bash
kubectl describe cronjob <cronjob-name>
```

> 🔹 View CronJob schedule, job template, and history.

---

## ⚖️ 7. Horizontal Pod Autoscaler (HPA)

**Use:** Automatically scale deployments based on CPU/memory usage.

```bash
kubectl get hpa
```

> 🔹 List all HPAs.

```bash
kubectl autoscale deployment <deployment-name> --min=<min> --max=<max> --cpu-percent=<percentage>
```

> 🔹 Create an autoscaler for a deployment.

---

## 🌐 8. Services

**Use:** Expose deployments and enable communication inside/outside the cluster.

```bash
kubectl get services
```

> 🔹 List all services.

```bash
kubectl describe service <service-name>
```

> 🔹 View service type, selector, and endpoints.

```bash
kubectl expose deployment <deployment-name> --port=<port> --target-port=<target-port>
```

> 🔹 Create a service for a deployment.

```bash
kubectl delete service <service-name>
```

> 🔹 Delete a service.

---

## 🌍 9. Ingress

**Use:** Manage HTTP/HTTPS access to services.

```bash
kubectl get ingress
```

> 🔹 List all ingress resources.

```bash
kubectl describe ingress <ingress-name>
```

> 🔹 Show ingress rules and backend services.

```bash
kubectl delete ingress <ingress-name>
```

> 🔹 Delete an ingress.

---

## 🧩 10. ConfigMaps and Secrets

**Use:** Manage configuration and sensitive data.

```bash
kubectl create configmap <configmap-name> --from-literal=<key>=<value>
```

> 🔹 Create a ConfigMap from literal values.

```bash
kubectl get configmaps
```

> 🔹 List all ConfigMaps.

```bash
kubectl create secret generic <secret-name> --from-literal=<key>=<value>
```

> 🔹 Create a Secret manually.

---

## 💾 11. Persistent Volumes (PV) and Persistent Volume Claims (PVC)

**Use:** Manage persistent storage.

```bash
kubectl get pv
```

> 🔹 List Persistent Volumes.

```bash
kubectl get pvc
```

> 🔹 List Persistent Volume Claims.

```bash
kubectl describe pv <pv-name>
```

> 🔹 View PV status, capacity, and access modes.

---

## 🖥 12. Nodes

**Use:** Manage Kubernetes cluster nodes.

```bash
kubectl get nodes
```

> 🔹 List all cluster nodes.

```bash
kubectl cordon <node-name>
```

> 🔹 Mark a node unschedulable (no new pods will be placed).

```bash
kubectl drain <node-name>
```

> 🔹 Evict pods safely before maintenance.

```bash
kubectl uncordon <node-name>
```

> 🔹 Allow scheduling on the node again.

---

## 🧩 13. Helm Commands

**Use:** Manage Helm charts for Kubernetes.

```bash
helm repo add <repo-name> <repo-url>
```

> 🔹 Add a new Helm repository.

```bash
helm install <release-name> <chart-name>
```

> 🔹 Install a Helm chart.

```bash
helm upgrade <release-name> <chart-name>
```

> 🔹 Upgrade an existing Helm release.

```bash
helm uninstall <release-name>
```

> 🔹 Remove a Helm release.

---

## 🧠 14. Troubleshooting

**Use:** Debug cluster resources and performance.

```bash
kubectl get events
```

> 🔹 List recent events across the cluster.

```bash
kubectl top pods
```

> 🔹 Show live CPU and memory usage for pods.

```bash
kubectl top nodes
```

> 🔹 Show resource usage across nodes.

---

## 🧭 15. Context Management

**Use:** Manage multiple cluster connections.

```bash
kubectl config get-contexts
```

> 🔹 View all configured contexts.

```bash
kubectl config use-context <context-name>
```

> 🔹 Switch between clusters quickly.

---

## 🧮 16. Resource Quotas and Limits

**Use:** Control resource allocation per namespace.

```bash
kubectl get resourcequotas
```

> 🔹 List all defined resource quotas.

```bash
kubectl describe resourcequota <resourcequota-name>
```

> 🔹 Display quota usage and limits.
