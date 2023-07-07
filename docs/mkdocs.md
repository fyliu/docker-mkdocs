# Mkdocs

## Introduction

### What is it

Mkdocs is a documentation generator for projects, which converts markdown to html.

### Why we use it

It creates documentation that's pleasing to read and easy to maintain.

???+ info "Here's a list of features we use"

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

## Hackforla project template

???+ abstract "Todo"

    - [x] how to extend to install other plugins in ci.yml and Dockerfile
    - [ ] multirepo plugin
    - [ ] ~~optimize Dockerfile~~
    - [ ] ~~[people depot] auto merge docs branch with gh-actions~~

#### Components

1. Starter docs to guide the creation of new pages.
1. Github workflow setup to auto-deploy the documentation.
1. Docker setup to run mkdocs without having to install it locally

### Usage

=== "New project"

    When we create a new project from the template, mkdocs should already be usable. The github workflow will run automatically and create a github pages site at `http://hackforla.github.io/<project name>`

    1. Click on ++"Use this template"++
    1. "Create a new repository"
    1. Set the relevant options
    1.
    ???+ info

        Be sure to check the "copy all branches" option

=== "Existing project"

    To add mkdocs to existing repos. You'll need to copy these files into your project

    ```
    .github/workflows/ci.yml
    docker-compose.mkdocs.yml
    ```

    You'll also need to create a new mkdocs project

    1. Use the docker image to create the new project

    ``` bash
    docker-compose -f docker-compose.mkdocs.yml run mkdocs mkdocs new . # (1)!
    ```

    1. docker-compose run executes a command from a new docker image container. In this case, inside the mkdocs container, execute `mkdocs new .` (note the period for the current directory).



#### Working on docs locally

1. Run the mkdocs server with the following command

    ``` bash
    docker-compose -f docker-compse.mkdocs.yml up
    ```

2. Work on the docs.
3. ++ctrl+c++ to stop the server.

### Extension

If your project wants to try other plugins not in the hackforla image, here's a way to extend the image on your own before asking to add it to the hackforla image.

??? info "The hackforla image is built from [hackforla/mkdocs-docker](https://github.com/hackforla/ghpages-docker), where the mkdocs plugins are listed in `pyproject.toml`."

1. In ci.yml, add the instruction to install the extnesion

    ``` yaml title=".github/workflows/ci.yml" hl_lines="3"
          - run: pip install \
              mkdocs-material \
              mkdocs-awesome-pages-plugin \
              ...
    ```

1. Add your own Dockerfile to install the plugin for local usage

     ```docker title="Dockerfile.mkdocs"
     # base image
     FROM fyliu/local-mkdocs:testing

     # set work directory
     WORKDIR /app

     # install system dependencies
     RUN apt-get update \
       && apt-get --no-install-recommends install -y \
       git # mkdocs-multirepo-plugin requires this \
       && apt-get clean \
       && rm -rf /var/lib/apt/lists/*

     # install dependencies
     # (1)!
     COPY requirements.txt .
     RUN pip install --no-cache-dir -r requirements.txt

     # copy project
     COPY . .
     ```

    1. Presumably, the extra plugins are specified in requirement.txt to be installed

1. Modify the docker-compose file to use the new Dockerfile

    ``` yaml title="docker-compose.mkdocs.yml" hl_lines="2-5"
    mkdocs:
        #image: fyliu/local-mkdocs:testing
        build:
        context: .
        dockerfile: Dockerfile.mkdocs
        container_name: mkdocs
    ```

??? info "How we set it up"

    ### Github workflow

    We're using essentially the same workflow described [here](https://squidfunk.github.io/mkdocs-material/publishing-your-site/).

    This builds and publishes the docs on push to the main branch.

    ``` yaml title=".github/workflow/ci.yml"
    name: ci
    on:
      push:
        branches:
          - main
    jobs:
      deploy:
        runs-on: ubuntu-latest
        permissions:
          contents: write # (1)!
        steps:
          - uses: actions/checkout@v2
          - uses: actions/setup-python@v2
            with:
              python-version: 3.x
          - run: pip install mkdocs-material
          - run: mkdocs gh-deploy --force
    ```

    1. Request repo commit permission inside the deploy job.

    ### Docker image

    There's a docker image that contains the standard mkdocs setup we use at Hack for LA. It contains all the plugins that projects are using. If your project requires other ones, Either request one to be added to the image or create your own dockerfile for installing them.

    ??? note "Temporarily, the image is in a personal dockerhub repo `fyliu/local-mkdocs:testing` until it can be moved under a hackforla account. The source repo for the image is [here](https://github.com/fyliu/fyliu.github.io)"

    Projects can use the image by creating a docker-compose.yml file like this

    ``` yaml title="docker-compose.mkdocs.yml"
    version: "3.9"
    services:
      mkdocs:
        image: fyliu/local-mkdocs:testing
        container_name: mkdocs # (1)!
        command: mkdocs serve -a "0.0.0.0:8000"
        ports:
          - "8000:8000" # (2)!
        volumes:
          - .:/app
    ```

    1. If the name conflicts with another container, we suggest customizing this with your project name, like `mkdocs-engineering` or `mkdocs-website`.
    1. If port 8000 is already in use, change this to something like 8001:8000 to expose it on port 8001.

## Mkdocs docker image repo
### How to use it

=== "Docker"

    #### Docker

    1. Build the image

        ```bash
        docker-compose build
        ```

    1. Start the container

        ```bash
        docker-compose up
        ```

    1. Open a browser to `http://localhost:8000/` to see the documentation locally

    1. Modify the files in the docs directory. The site will auto update when the files are saved.

    1. Quit

        ++ctrl+c++ to quit the local server and stop the container

=== "Local install (pip)"

    #### Local Install (pip)

    python should be version 3

    1. Install mkdocs

        ``` bash
        pip install -r requirements.txt
        ```

    1. Start the local server

        ```bash
        mkdocs serve -a localhost:8000
        ```

    1. Open a browser to `http://localhost:8000/` to see the documentation locally

    1. Modify the files in the docs directory. The site will auto update when the files are saved.

    1. Quit

        ++ctrl+c++ to quit mkdocs

=== "Local install (poetry)"

    #### Local Install (poetry)

    python poetry must be installed in the local system

    1. Install mkdocs

        ```bash
        poetry install
        ```

    1. Start the local server

        ```bash
        poetry shell
        mkdocs serve -a localhost:8000
        ```

    1. Open a browser to `http://localhost:8000/` to see the documentation locally

    1. Modify the files in the docs directory. The site will auto update when the files are saved.

    1. Quit

        ++ctrl+c++ to quit mkdocs

        ```bash
        exit  # (1)!
        ```

        1. to close poetry shell environment

??? info "How we set it up"

    ### Setup from scratch

    Here's the recommended setup, from our experience setting it up.

    #### Project directory

    ```bash
    mkdir mkdocs-notes && cd $_
    git init
    git commit —allow-empty -m”Initial commit”
    ```

    #### Poetry project
    ```bash
    poetry init —name docs —description “Project Documentation” # (1)!
    # use a modern stable python like version 3.11.1
    # don’t define dependencies interactively
    git commit -m”create project for documentation”
    ```

    1. We chose poetry because it performs multiple useful functions such as creating the virtual environment and dependency management. It will be easy to update to the latest versions of dependencies.

    #### Mkdocs package
    ```bash
    poetry shell # this goes into the poetry virtual environment
    poetry add mkdocs --group docs
    # group replaces dev dependencies
    git add pyproject.toml poetry.lock
    git ci -m”add mkdocs package”
    ```

    #### Mkdocs project
    ```bash
    mkdocs new . # creates mkdocs project in current directory
    git add -A # add all untracked files
    git ci -m”create mkdocs project”
    ```

    #### Local dev server

    ```bash
    mkdocs serve —dev-addr 0.0.0.0:8000 # (1)!
    ```

    1. Start the dev server locally on any address on port 8000.
    This is useful for development from a different local network computer, where the default localhost won’t work

    #### Material theme
    ```bash
    poetry add mkdocs-material
    cat "theme: material" >> mkdocs.yml
    git ci -a -m"setup material theme for mkdocs"
    ```

    #### ~~Multirepo~~ (not yet working)
    ```bash
    poetry add mkdocs-multirepo-plugin
    # add the plugin in mkdocs.yml
    # import the other repos in mkdocs.yml
    ```

    #### Export requirements

    We need to export the requirements whenever we add a new package, so that the docker setup and pip users can know to use it.

    ```bash
    # (1)!
    poetry export -f requirements.txt --without-hashes > requirements.txt --with docs
    ```

    1. This is also contained in a script `export_requirements.sh` in the scripts directory

    #### Deployment to Github Pages

    We closely followed [this guide](https://squidfunk.github.io/mkdocs-material/publishing-your-site/).
    This setup creates a gh-pages branch to store the latest docs. Make the necessary configurations in the Github repo settings as necessary under Pages.

    #### Docker setup

    We modified the dockerfile and docker-compose files from People Depot to install and serve mkdocs locally.
    The files are `docker-compose.yml` and `Dockerfile`.
