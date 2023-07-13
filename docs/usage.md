# User Guide

## Introduction

### What is it

Mkdocs is a static site generator for documentation that converts markdown to html.

### Why we use it

It comes with tools to help create documentation that's pleasing to read and easy to maintain.

??? info "Here's a list of features we use"

    ??? example "Dead link checker"

        Github wiki doesn't check for broken links.

    ??? example "Search function"

        Github wiki is not searcheable.

    ??? example "[Tabbed blocks](https://facelessuser.github.io/pymdown-extensions/extensions/tabbed/)"

        === "Linux"

            linux-specific content

        === "Mac"

            mac-specific content

    ??? example "Site table of contents"

        See the contents of the site in the left sidebar.

    ??? example "Per-page table of contents"

        See the contents of the current page in the right sidebar.

    ??? example "Code and text annotations"

        ``` bash
        Click the plus sign --> # (1)!
        ```

        1. This is an explanation text

    ??? example "[Expandable text blocks](https://facelessuser.github.io/pymdown-extensions/extensions/blocks/plugins/details/)"

        That's what this box is!

### Why we made a docker image for it

We want to make it very easy for Hack for LA projects to maintain documentation. Having a docker image would allow:

- Hack for LA
    - one location to update the mkdocs setup for all projects
- projects
    - time saving of not having to set up mkdocs
    - the flexibility to customize configuration even though the image is the same across projects
- devs
    - time saving of not having to set up mkdocs
    - to use a simple command to serve and work on documentation locally

## Mkdocs docker image

### How to use it

#### Add it to a  project

1. Copy this file into your project.

    ``` bash
    .github/workflows/ci.yml
    ```

    This workflow automates deployment to gh-pages. Make sure you have Pages set to deploy from the `gh-pages` branch.

1. Create `docker-compose.mkdocs.yml`.

    The `.mkdocs` in the name makes it so it doesn't conflict with the main `docker-compose.yml` in the project.

    ``` yaml title="docker-compose.mkdocs.yml"
    version: "3.9"
    services:
      mkdocs:
        # (1)!
        image: hackforlaops/mkdocs:latest
        # build:
        #   context: .
        #   dockerfile: Dockerfile
        container_name: mkdocs
        # (2)!
        command: mkdocs serve -a "0.0.0.0:8000"
        # (3)!
        ports:
          - "8001:8000"
        # (4)!
        volumes:
          - .:/app
    ```

    1. Use the pre-built image file from this project.
    2. Expose the site to all IPs. This enables browsing the site from another local computer.
    3. Expose the site on port 8001, in case 8000 is in use by the project.
    4. Map the current directory to the /app directory in the container.

1. Create a new mkdocs project

    1. Use the docker image to create the new project

    ``` bash
    docker-compose -f docker-compose.mkdocs.yml run mkdocs mkdocs new . # (1)!
    ```

    1. docker-compose run executes a command from a new docker image container. In this case, inside the mkdocs container, execute `mkdocs new .` (note the period for the current directory).

#### Work on docs locally

1. Run the mkdocs server from the container

    ``` bash
    docker-compose -f docker-compse.mkdocs.yml up
    ```

1. Open a browser to `http://localhost:8001/` to see the documentation locally

1. Modify the files in the docs directory. The site will auto-update when the files are saved.

1. Quit

    ++ctrl+c++ to quit the local server and stop the container

### Extend the image

If your project wants to try other plugins not in the hackforla image, here's a way to extend the image on your own before asking to add it to the hackforla image.

??? info "The hackforla image is built from [hackforla/mkdocs-docker](https://github.com/hackforla/ghpages-docker), where the mkdocs plugins are listed in `pyproject.toml`."

#### Get poetry

1. Add your own Dockerfile to install the plugin for local usage that also installs poetry

     ```docker title="Dockerfile.mkdocs" hl_lines="17"
     # base image
     FROM hackforlaops/mkdocs:latest

     # set work directory
     WORKDIR /app

     # install system dependencies
     # (2)!
     #RUN apt-get update \
     #  && apt-get --no-install-recommends install -y \
     #  git # mkdocs-multirepo-plugin requires this \
     #  && apt-get clean \
     #  && rm -rf /var/lib/apt/lists/*

     # install dependencies
     # (3)!
     RUN pip install --no-cache-dir poetry
     # (1)!
     COPY requirements.txt .
     RUN pip install --no-cache-dir -r requirements.txt

     # copy project
     COPY . .
     ```

    1. Presumably, the extra plugins are python packages specified in requirement.txt to be installed.
    2. Remove or comment out the block unless the plugin requires non-python package installation.
    3. Poetry adds 60MB to the image, bringing the image size from 310MB to 370MB.

1. Reference the new Dockerfile in the docker-compose file

    ``` yaml title="docker-compose.mkdocs.yml" hl_lines="3-6"
    ...
      mkdocs:
          #image: hackforlaops/mkdocs:latest
          build:
          context: .
          dockerfile: Dockerfile.mkdocs
          container_name: mkdocs
    ...
    ```

1. Build the image.

    ``` bash
    docker-compose -f docker-compse.mkdocs.yml build
    ```

#### Add the new plugin

1. Create a pyproject.yml similar to the one in this repo.

    ``` yaml title="pyproject.yml"
    [tool.poetry]
    name = "project-name"
    version = "0.1.0"
    description = ""
    authors = []
    readme = "README.md"

    [tool.poetry.dependencies]
    python = "^3.11.4" # (1)!

    [build-system]
    build-backend = "poetry.core.masonry.api"
    requires = [
      "poetry-core",
    ]
    ```

    1. This is the python version in the `hackforla/docker-mkdocs/pyproject.toml` file. It can also be the version that's in the `hackforla/docker-mkdocs/Dockerfile`.

1. Add the new plugin

    ``` bash
    docker-compose -f docker-compse.mkdocs.yml run mkdocs \ # (1)!
    poetry add mkdocs-awesome-pages # (2)!
    ```

    1. This docker-compose command runs the next line inside the docker container
    2. Add (install) mkdocs-awesome-pages to pyproject.toml.

#### Try it

1. Export the requirements.txt

    ```bash
    # (1)!
    docker-compose -f docker-compse.mkdocs.yml run mkdocs \
    poetry export -f requirements.txt --without-hashes > requirements.txt --with docs # (2)!
    ```

    1. This is also contained in a script `export_requirements.sh` in the scripts directory of this project.
    2. Export in requirements.txt format, to requirements.txt, with docs group dependencies.

1. Build and run the docker image with the new plugin

    ``` bash
    docker-compose -f docker-compse.mkdocs.yml up --build
    ```

1. Add any configuration to mkdocs.yml
1. Use it in the documentation
1. Test that the plugin works

#### Add it to CI

1. In ci.yml, add the instruction to install the extension

    ``` yaml title=".github/workflows/ci.yml" hl_lines="4"
    ...
          - run: pip install \
              mkdocs-material \
              mkdocs-awesome-pages-plugin \
              ...
    ...
    ```

#### Add it to the hackforla image

If the plugin works well for your project, and you would like it to be added at the organization level. Please do as much of the following as you can.

1. Create a documentation page about the plugin: What it is, how it's useful, how to use it. etc..
1. Create a PR in `hackforla/docker-mkdocs` with the necessary changes to add the plugin, including the documentation page.
1. Follow up in slack if necessary.
