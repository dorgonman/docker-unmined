#!/bin/sh
set -e

if [ -z "$SERVICE_HOME" ]; then
  echo "SERVICE_HOME is not set, use default"
  SERVICE_HOME="/var/lib/docker/volumes/app/minecraft-bedrock-server"
fi

containerName="unmined-gui-1"
# stop and remove container
docker stop ${containerName} || true
docker rm ${containerName} || true
# build docker image
cmd="docker build -t local/unmined ."
echo $cmd
eval $cmd
# chekc if USER_UID and USER_GID are set
if [ -z "$USER_UID" ]; then
  echo "USER_UID is not set, use default"
  USER_UID=1000
fi
if [ -z "$USER_GID" ]; then
  echo "USER_GID is not set, use default"
  USER_GID=1000
fi

rm -rf ${SERVICE_HOME}/docker-unmined
mkdir -p ${SERVICE_HOME}/docker-unmined
chown -R ${USER_UID}:${USER_GID} ${SERVICE_HOME}/docker-unmined
chmod -R 755 ${SERVICE_HOME}/docker-unmined
chmod -R 755 ${SERVICE_HOME}/data/worlds
# run
        #  \
cmd="docker run --name ${containerName} -d \
    --user ${USER_UID}:${USER_GID} \
        -p 8080:8080 \
        --env 'CUSTOM_RES_W=1280' \
        --env 'CUSTOM_RES_H=850' \
        --env 'UID=${USER_UID}' \
        --env 'GID=${USER_GID}' \
        --env 'UMASK=000' \
        --env 'DATA_PERM=770' \
    	--volume ${SERVICE_HOME}/docker-unmined:/unmined \
        --volume ${SERVICE_HOME}/data/worlds:/unmined/worlds:ro \
        local/unmined"
echo $cmd
eval $cmd                                                                                                                                                                                                                           