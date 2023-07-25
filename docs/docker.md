# Docker

## Remove extra files from docker image using `.dockerignore`

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
