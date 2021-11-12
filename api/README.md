# Python Flask Restapi

## Run application on the local;

```local
pip install -r requirements.txt
```

```local
$ python app.py
```

## Run application as a Container on the Docker

**Build the container image with your latest code and dependencies;**
```local
docker build -t python-restapi:0.1 .
```

**Run the application as a Container on the Docker;**
* Bind the local 5000 port to container 5000 port on the Docker host
* Set the Container Name to run in Docker 
```local
docker run -d -p 5000:5000 --name python-restapi python-restapi:0.1
```

**Show and follow the container logs;**
```local
docker logs python-restapi -f
```

**Connect to running container terminal;**
```local
docker exec -it  python-restapi /bin/sh
```
