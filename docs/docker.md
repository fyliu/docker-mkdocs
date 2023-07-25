# Docker

## Remove extra files from docker image using `.dockerignore`

1. Look into the image to find extra unneeded files

    ``` bash
    docker run -it image_name bash
    ```

1. Add the extra files and paths in `.dockerignore`

1. Rebuild the image
