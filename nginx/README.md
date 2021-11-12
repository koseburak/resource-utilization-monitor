# Nginx Reverse Proxy Server Container

Build the Image to run on the local Docker
```local
docker build -t funf/observer:nginx-0.0.2 .
```
Build the Image to run on the AWS ECS
```local
docker build --build-arg NGINX_CONF=aws-ecs -t funf/observer:nginx-0.0.2 .
```
