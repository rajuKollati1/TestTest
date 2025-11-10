⚙️ Basic kubectl Commands
| Command                | Description       | Example                     |
| ---------------------- | ----------------- | --------------------------- |
| `kubectl version`      | Show K8s version  | `kubectl version --short`   |
| `kubectl cluster-info` | Cluster details   | `kubectl cluster-info`      |
| `kubectl get nodes`    | List all nodes    | `kubectl get nodes -o wide` |
| `kubectl get all`      | Get all resources | `kubectl get all`           |

🧱 Pod Commands
| Command                               | Description      | Example                        |
| ------------------------------------- | ---------------- | ------------------------------ |
| `kubectl get pods`                    | List pods        | `kubectl get pods -o wide`     |
| `kubectl describe pod <pod>`          | Show pod details | `kubectl describe pod nginx`   |
| `kubectl logs <pod>`                  | View pod logs    | `kubectl logs nginx`           |
| `kubectl exec -it <pod> -- /bin/bash` | Access pod shell | `kubectl exec -it nginx -- sh` |
| `kubectl delete pod <pod>`            | Delete pod       | `kubectl delete pod nginx`     |

🚀 Deployment Commands
| Command                                            | Description          | Example                                                |
| -------------------------------------------------- | -------------------- | ------------------------------------------------------ |
| `kubectl create deployment <name> --image=<image>` | Create a deployment  | `kubectl create deployment nginx --image=nginx:latest` |
| `kubectl get deployments`                          | List deployments     | `kubectl get deploy`                                   |
| `kubectl scale deployment <name> --replicas=<n>`   | Scale replicas       | `kubectl scale deployment nginx --replicas=3`          |
| `kubectl rollout status deployment/<name>`         | Check rollout status | `kubectl rollout status deployment/nginx`              |
| `kubectl delete deployment <name>`                 | Delete deployment    | `kubectl delete deployment nginx`                      |

🌐 Service Commands
| Command                                                        | Description         | Example                                                     |
| -------------------------------------------------------------- | ------------------- | ----------------------------------------------------------- |
| `kubectl expose deployment <name> --port=<port> --type=<type>` | Expose a deployment | `kubectl expose deployment nginx --port=80 --type=NodePort` |
| `kubectl get svc`                                              | List services       | `kubectl get svc`                                           |
| `kubectl describe svc <name>`                                  | Service details     | `kubectl describe svc nginx`                                |
| `kubectl delete svc <name>`                                    | Delete service      | `kubectl delete svc nginx`                                  |

🧾 ConfigMap & Secret Commands
| Command                                                       | Description      | Example                                                                |
| ------------------------------------------------------------- | ---------------- | ---------------------------------------------------------------------- |
| `kubectl create configmap <name> --from-literal=<k>=<v>`      | Create ConfigMap | `kubectl create configmap app-config --from-literal=env=prod`          |
| `kubectl get configmaps`                                      | List ConfigMaps  | `kubectl get cm`                                                       |
| `kubectl create secret generic <name> --from-literal=<k>=<v>` | Create Secret    | `kubectl create secret generic db-secret --from-literal=password=1234` |
| `kubectl get secrets`                                         | List Secrets     | `kubectl get secrets`                                                  |

🧰 Apply, Describe & Delete via YAML
| Command                         | Description         | Example                            |
| ------------------------------- | ------------------- | ---------------------------------- |
| `kubectl apply -f <file>.yaml`  | Apply configuration | `kubectl apply -f deployment.yaml` |
| `kubectl create -f <file>.yaml` | Create resource     | `kubectl create -f pod.yaml`       |
| `kubectl delete -f <file>.yaml` | Delete resource     | `kubectl delete -f service.yaml`   |

🧩 Namespace & Context Commands
| Command                                                 | Description      | Example                                                |
| ------------------------------------------------------- | ---------------- | ------------------------------------------------------ |
| `kubectl get ns`                                        | List namespaces  | `kubectl get ns`                                       |
| `kubectl create ns <name>`                              | Create namespace | `kubectl create ns dev`                                |
| `kubectl delete ns <name>`                              | Delete namespace | `kubectl delete ns dev`                                |
| `kubectl config set-context --current --namespace=<ns>` | Switch namespace | `kubectl config set-context --current --namespace=dev` |

🧭 Cluster & Node Commands
| Command                        | Description        | Example                                    |
| ------------------------------ | ------------------ | ------------------------------------------ |
| `kubectl get nodes`            | List nodes         | `kubectl get nodes -o wide`                |
| `kubectl describe node <name>` | Node details       | `kubectl describe node node01`             |
| `kubectl cordon <node>`        | Mark unschedulable | `kubectl cordon node01`                    |
| `kubectl drain <node>`         | Drain node         | `kubectl drain node01 --ignore-daemonsets` |
| `kubectl uncordon <node>`      | Uncordon node      | `kubectl uncordon node01`                  |

📊 Monitoring Commands
| Command                                                    | Description     | Example              |
| ---------------------------------------------------------- | --------------- | -------------------- |
| `kubectl top pods`                                         | Show pod usage  | `kubectl top pods`   |
| `kubectl top nodes`                                        | Show node usage | `kubectl top nodes`  |
| `kubectl get events --sort-by=.metadata.creationTimestamp` | List events     | `kubectl get events` |

📘 Help Commands
kubectl --help
kubectl get pods --help
kubectl explain pod

🏁 Summary

Master Node: Controls and manages the cluster.

Worker Node: Runs the applications (pods).

kubectl: Command-line tool to interact with Kubernetes.

YAML files: Used for declarative configurations.
