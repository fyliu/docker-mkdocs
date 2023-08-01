# Docker

## How to remove extra project files from docker image

We use the `.dockerignore` file for this. It marks project files to skip when building the docker image.

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

## Cache mount

This helps speed up subsequent docker builds by caching intermediate files and reusing them across builds. It's available with docker buildkit. The key here is to disable anything that would delete the cache, because we want to preserve it. The cache mount is not going to end up in the docker image being built, so there's no concern about disk space usage.

Put this flag between `RUN` and the command

``` docker hl_lines="2"
RUN \
--mount=type=cache,target=/root/.cache
  pip install -r requirements.txt
```

For us using pip, the files are stored in `/root/.cache/pip`.

??? info "References"
    - buildkit mount the cache https://vsupalov.com/buildkit-cache-mount-dockerfile/
    - proper usage of mount cache https://dev.doroshev.com/blog/docker-mount-type-cache/
    - mount cache reference https://docs.docker.com/engine/reference/builder/#run---mounttypecache

## Reduce the image size

There are methods to do this on many levels. All of these methods contribute to reduce the final image size. We list ones we considered but didn't use in order to explain why.

### Docker

1. Docker cache mount

    See [cache mount](#cache-mount) above. There's no need to delete any files since they're in a cache mount that's not part of the docker image.

### Python

1. Python skip bytecode generation

    === "env variable"

        We can set this environment variable

        ``` docker
        ENV PYTHONDONTWRITEBYTECODE 1
        ```

    === "command env"

        Or we can set it before the command, like this

        ``` docker
        RUN PYTHONDONTWRITEBYTECODE=1 pip install -r requirements.txt
        ```

1. pycache prefix and rm

    Set this environment variable to make python store all pycache bytecode files under some directory

    ``` docker
    ENV PYTHONPYCACHEPREFIX=/pycache/
    ```

    Or use the commandline flag for python

    ``` docker
    RUN python3 -X pycache_prefix=/pycache/ -m pip install -r requirements.txt
    ```

    Then remove the files in the same RUN command by appending this to the end

    ``` bash
    rm -rf /pycache /root/.cache
    ```

### Pip

1. Pip don't compile python into byte code

    Just pass the flag into pip to skip generating `pyc` files during install

    ``` docker
    RUN pip install --no-compile -r requirements.txt
    ```

1. Pip no cache dir (unused because the cache is not part of the image anyway, and it speeds up subsequent builds)

    Set this environment variable

    ``` bash
    ENV PIP_NO_CACHE_DIR=1 \
    ```

    Or pass this flag into pip

    ``` bash
    RUN pip install --no-cache-dir -r requirements.txt
    ```

1.
