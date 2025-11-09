# Kubernetes Networking and Ingress

## Expose Service
```bash
kubectl expose deployment myapp --type=NodePort --port=80
```

## Ingress Example
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp-ingress
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```
