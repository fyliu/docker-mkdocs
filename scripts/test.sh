#!/bin/bash
set -eux

docker-compose exec mkdocs sh -c "mkdocs build --strict"
