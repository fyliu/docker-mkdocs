# MkDocs

## Welcome to MkDocs

For full documentation visit [mkdocs.org](https://www.mkdocs.org).

## Commands

* `mkdocs new [dir-name]` - Create a new project.
* `mkdocs serve` - Start the live-reloading docs server.
* `mkdocs build` - Build the documentation site.
* `mkdocs -h` - Print help message and exit.

## Project layout

    mkdocs.yml    # The configuration file.
    docs/
        index.md  # The documentation homepage.
        ...       # Other markdown pages, images and other files.

???+ abstract "Todo"

    - [x] how to extend to install other plugins in ci.yml and Dockerfile
    - [ ] multirepo plugin
    - [ ] ~~optimize Dockerfile~~
    - [ ] ~~[people depot] auto merge docs branch with gh-actions~~

### How to set it up for development

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

#### How to update the package versions

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
