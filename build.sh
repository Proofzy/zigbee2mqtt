#!/bin/bash -e

if [ -z "$1" ]; then 
    gittag=$(git rev-parse --short HEAD)
else 
    gittag=$1
fi

podman build --platform=linux/arm64 -t containerhub.cedar.eaccess.dk/zigbee2mqtt:latest -t containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}  -f docker/Dockerfile
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:latest 
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}

echo Latest version: ${gittag}
