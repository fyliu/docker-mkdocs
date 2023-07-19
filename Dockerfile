# pull official base image
FROM python:3.11-alpine3.18

# set work directory
WORKDIR /app

# install system dependencies
RUN apk add --no-cache \
git=2.40.1-r0 # mkdocs-multirepo-plugin requires this

# install dependencies
RUN pip install --no-cache-dir poetry==1.5.1
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# copy project
COPY . .
