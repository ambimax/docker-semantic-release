#!/usr/bin/env bash

# exit on error
set -e

RED='\033[0;31m'
NC='\033[0m' # No Color

error_exit() {
    echo -e "${RED}$1${NC}"
    exit 1
}

############################################################################################
# Validate
############################################################################################
docker images | grep -e "ambimax/semantic-release.*latest" || error_exit "Image ambimax/semantic-release:latest not found"
[ -n "$SEMANTIC_VERSION" ] || error_exit "\$SEMANTIC_VERSION not set"

############################################################################################
# Tag images
############################################################################################
docker tag "ambimax/semantic-release:latest" "docker.io/ambimax/semantic-release:latest"
docker tag "ambimax/semantic-release:latest" "docker.io/ambimax/semantic-release:${SEMANTIC_VERSION}"


############################################################################################
# Push images
############################################################################################
docker image push "docker.io/ambimax/semantic-release:latest"
docker image push "docker.io/ambimax/semantic-release:${SEMANTIC_VERSION}"
