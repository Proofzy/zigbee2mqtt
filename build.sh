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
git checkout ed3bcd5ccc99c5d66431bba3e2e0d6786884b492
npm install
npm run build
rm -r node_modules
popd

podman build --build-arg COMMIT=$gittag --platform=linux/arm64 -t containerhub.cedar.eaccess.dk/zigbee2mqtt:latest -t containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}  -f docker/Dockerfile --target release .
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:latest 
podman push containerhub.cedar.eaccess.dk/zigbee2mqtt:${gittag}

echo Latest version: ${gittag}
