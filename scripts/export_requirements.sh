#!/bin/bash
set -eux

# Assumes
#   - uv is installed
#   - this script is run from the root of the repo
uvx uv pip compile pyproject.toml -o requirements.txt
