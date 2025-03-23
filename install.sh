#!/bin/sh
set -e

if [ -z "$SERVICE_HOME" ]; then
  echo "SERVICE_HOME is not set, use default"
  SERVICE_HOME="/var/lib/docker/volumes/app/minecraft-bedrock-server"
fi

# build docker image
cmd="docker build -t local/unmined ."
echo $cmd
eval $cmd

userUID=$(id -u)
userGID=$(id -g)

mkdif -p ${SERVICE_HOME}/docker-unmined
chmod -R 755 ${SERVICE_HOME}/docker-unmined
chmod -R 755 ${SERVICE_HOME}/data/worlds
# run
	#  \
cmd="docker run --name unmined-gui -d \
    --user ${userUID}:${userGID} \
	-p 8080:8080 \
	--env 'CUSTOM_RES_W=1280' \
	--env 'CUSTOM_RES_H=850' \
	--env 'UID=${userUID}' \
	--env 'GID=${userGID}' \
	--env 'UMASK=000' \
	--env 'DATA_PERM=770' \
    --volume ${SERVICE_HOME}/docker-unmined:/unmined \
	--volume ${SERVICE_HOME}/data/worlds:/unmined/worlds:ro \
	local/unmined"
echo $cmd
eval $cmd