#!/bin/bash
set -eux

docker-compose -f docker-compose.yml run mkdocs sh -c "\
poetry export -f requirements.txt --without-hashes > requirements.txt\
"
set +x
#docker-compose -f docker-compose.yml run mkdocs sh -c "poetry update &&
#poetry export -f requirements.txt --without-hashes > requirements.txt --with dev"
