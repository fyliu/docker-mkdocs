# pull official base image
FROM python:3.11.4-slim-bookworm

# set work directory
WORKDIR /app

# install system dependencies
RUN apt-get update \
  && apt-get --no-install-recommends install -y \
  git # mkdocs-multirepo-plugin requires this \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# install dependencies
#RUN pip install --no-cache-dir poetry==1.5.1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .
