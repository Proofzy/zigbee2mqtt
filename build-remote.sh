#!/bin/bash -ex

gittag=$(git rev-parse --short HEAD)
excludefile=$(mktemp)
git -C . ls-files --exclude-standard -oi --directory > "${excludefile}"
rsync -r -avz --delete --exclude="node_modules/*" --exclude ".git" --exclude-from=$excludefile . cedar@10.132.20.7:/home/cedar/build/zigbee2mqtt
ssh -l cedar 10.132.20.7 "cd /home/cedar/build/zigbee2mqtt/ && sudo ./build.sh $gittag"
