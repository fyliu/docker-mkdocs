## How to add poetry to the image

Adding poetry to the image lets us manage the project dependencies without installing it on the host machine.

1. Add poetry to Dockerfile

    ```docker title="Dockerfile" hl_lines="5"
    ...
    # install dependencies
    COPY requirements.txt .
    RUN pip install --no-cache-dir -r requirements.txt
    RUN pip install --no-cache-dir poetry==1.5.1
    ...
    ```

1. Build the image

    ``` bash
    docker-compose build
    ```

    Now we can call poetry that's in the image

## How to add a package

pyproject-fmt is an auto-formatter for the pyproject.toml configuration file.

1. Get a shell inside the container

``` bash
docker-compose run mkdocs sh
```

1. Install and run the package

``` bash
pip install pyproject-fmt
pyproject-fmt pyproject.toml
```

## How to add package to a group

Organizing packages into groups allows better organization of dependencies. For example, dev dependencies and docs dependencies as opposed to the ones for the main application.

``` bash
poetry add pytest --group dev
```
