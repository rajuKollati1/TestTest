# TF-Jenkins

This folder is created for Jenkins-related Terraform practice and Helm deployment notes.

## Jenkins Installation on Kubernetes using Helm

### 1) Add the Jenkins Helm repo
```bash
helm repo add jenkins https://charts.jenkins.io
helm repo update
```

### 2) Create a namespace
```bash
kubectl create namespace jenkins
```

### 3) Install Jenkins
```bash
helm install jenkins jenkins/jenkins -n jenkins
```

### 4) Check the release status
```bash
kubectl get pods -n jenkins
kubectl get svc -n jenkins
```

### 5) Get the admin password
```bash
kubectl exec --namespace jenkins -it svc/jenkins -- /bin/cat /run/secrets/chart-admin-password
```

### 6) Get the Jenkins URL
```bash
kubectl --namespace jenkins get svc jenkins
```

If the service is of type LoadBalancer, access Jenkins using the external IP.
If not, use port-forward:

```bash
kubectl port-forward svc/jenkins 8080:8080 -n jenkins
```

Then open:
```text
http://localhost:8080
```

### 7) Login credentials
- Username: admin
- admin123

## Notes
- Make sure your Kubernetes cluster has enough resources for Jenkins.
- You can upgrade later with:
```bash
helm upgrade jenkins jenkins/jenkins -n jenkins
```
winget install EclipseAdoptium.Temurin.17.JRE
install java after that 

create folder in c:\Jenkins add below

curl.exe -O http://192.168.1.10:32591/jnlpJars/agent.jar

cd C:\Jenkins

java -jar agent.jar -url http://192.168.1.10:32591/ -secret fe1a47a38c179abe42d33de0ac03833428f36a1ff290ac630cace7a2252c5497 -name "windows agent" -webSocket -workDir "C:\Jenkins"