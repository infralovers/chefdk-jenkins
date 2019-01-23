# chefdk-jenkins

A custom jenkins docker image to run chefdk operations within this image. 

## Build it

```bash
docker build -t infralovers/chefdk-jenkins:latest .
```

To use a different jenkins:slave version:

```bash
docker build -t infralovers/chefdk-jenkins:latest --build-arg SLAVE_VERSION=3.26-1 .
```

To switch the chefdk version you can use following parameter

```bash
docker build -t infralovers/chefdk-jenkins:latest --build-arg CHEF_VERSION=3.5.13 .
```

You can also combine those parameters to customize the docker image.

## Run it

```bash
docker run -d \
  -p 2222:22 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name chefdk-jenkins \
  infralovers/chefdk-jenkins:latest
```
