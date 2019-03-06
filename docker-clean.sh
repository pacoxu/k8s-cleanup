#!/bin/bash

while true; do
  # Remove exited containers
  curl -X POST  --unix-socket /var/run/docker.sock http:/v1.24/containers/prune
  # Remove dangling images
  curl -X POST  --unix-socket /var/run/docker.sock http:/v1.24/images/prune?dangling=true
  # Remove dangling volumes
  curl -X POST  --unix-socket /var/run/docker.sock http:/v1.24/volumes/prune

  # DOCKER_CLEAN_INTERVAL defaults to 1 day
  sleep $DOCKER_CLEAN_INTERVAL
done
