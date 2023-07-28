# syntax = docker/dockerfile:1.3

# pull official base image
FROM python:3.11-alpine3.18

# set work directory
WORKDIR /app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

#ENV PIP_NO_CACHE_DIR=1 \
ENV PIP_DISABLE_PIP_VERISON_CHECK=ON \
    PIP_DEFAULT_TIMEOUT=100
#    PYTHONPYCACHEPREFIX=/pycache/

# install system dependencies
#RUN apk add --no-cache \
#git=2.40.1-r0 # mkdocs-multirepo-plugin requires this

# install dependencies
COPY requirements.txt .
# use buildkit mount to specify the pip cache dir. Not sure if this is faster or not generating the cache is better
RUN --mount=type=cache,target=/root/.cache/pip \
  pip install --no-deps --no-compile -r requirements.txt #&& rm -rf /pycache /root/.cache
#RUN PYTHONDONTWRITEBYTECODE=1 python3 -m pip install --no-deps -r requirements.txt && rm -rf /pycache /root/.cache
#RUN python3 -X pycache_prefix=/pycache/ -m pip install --no-cache-dir --no-deps -r requirements.txt && rm -rf /pycache /root/.cache
#RUN pip install --no-cache-dir -r requirements.txt && pip cache purge
#RUN pip install --no-cache-dir poetry==1.5.1
