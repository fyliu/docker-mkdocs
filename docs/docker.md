# Docker

## How to remove extra files from docker image

We use the `.dockerignore` file for this.

1. Look into the image to find extra unneeded files

    1. Run a shell in the docker image

        ``` bash
        docker run -it image_name sh
        ```

    1. Look at the directory structure

        ``` bash
        ls
        ```

1. Add the extra files and paths in `.dockerignore`

1. Rebuild the image

## Mount cache

This helps speed up subsequent docker builds
- buildkit mount the cache https://vsupalov.com/buildkit-cache-mount-dockerfile/
- proper usage of mount cache https://dev.doroshev.com/blog/docker-mount-type-cache/
