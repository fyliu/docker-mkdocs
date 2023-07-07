# dockerhub

## getting started

```
https://docs.docker.com/docker-hub/quickstart/
https://www.linux.com/training-tutorials/how-use-dockerhub/
```

I created a repo in my account called local-mkdocs
The follow commands logs into dockerhub, tags the local image as testing, and pushes it to dockerhub

```
docker login --username=fyliu
docker images
docker tag b6047b203915 fyliu/local-mkdocs:testing
docker push fyliu/local-mkdocs:testing
```
