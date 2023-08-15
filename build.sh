#!/bin/bash -e

if [ -z "$1" ]; then 
    gittag=$(git rev-parse --short HEAD)
else 
    gittag=$1
fi

if [ ! -d zigbee-herdsman ] ; then
    git clone git@github.com:Proofzy/zigbee-herdsman.git zigbee-herdsman
else
    pushd zigbee-herdsman
    git fetch origin
    popd
fi

pushd zigbee-herdsman
git checkout 70a7f69ef5ca76b0a6c16b6e149457360ce6b76c
npm install
npm run build
rm -r node_modules
popd

podman build --build-arg COMMIT=$gittag --platform=linux/arm64 -t containerhub.cedar.eaccess.dk/zigbee2mqtt:latest -t containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}  -f docker/Dockerfile --target release .
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:latest 
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}

echo Latest version: ${gittag}
