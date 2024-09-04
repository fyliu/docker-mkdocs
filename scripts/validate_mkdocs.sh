#!/bin/bash
set -eux

docker-compose exec -T mkdocs sh -c "mkdocs build --strict"
