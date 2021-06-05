# proto-rails

Monolithic Docker image for rapid application DEVELOPMENT; can be improved/complexified to an orchestrated group of containers.

## try it

### Build the Dockerfile.

Or, pull the Docker [image from Docker Hub](https://cloud.docker.com/repository/registry-1.docker.io/jerng/proto-rails): 

`docker pull jerng/proto-rails`

### Then run the resulting image with:

`docker run --rm -it -p 3000:3000 TAG-OR-IMAGE-ID`

... then check your `http://localhost:3000`

## Current Technologies

- Docker
- Ruby on Rails
- MySQL
