# Docker Basics and Commands

## Overview
Docker allows packaging, distribution, and execution of applications in containers.

### Common Commands
```bash
docker build -t myapp:latest .
docker images
docker run -d -p 8080:80 myapp:latest
docker ps
docker exec -it <container_id> bash
docker logs <container_id>
docker stop <container_id>
docker rm <container_id>
```

### Dockerfile Example
```Dockerfile
FROM nginx:latest
COPY ./apps/appname/index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

