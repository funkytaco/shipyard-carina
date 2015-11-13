#!/bin/bash

source docker.env

if [ -s carina_swarm_ip.env ];
then
    source carina_swarm_ip.env
    if [ -z  "$CARINA_SWARM_IP" ];
        then
        echo "CARINA_SWARM_IP NOT SET in carina_swarm_ip.env"
        exit 1
    else
        SWARM_IP=$CARINA_SWARM_IP
    fi
else
    echo "Carina Swarm IP environment file missing."
fi

docker stop shipyard-rethinkdb
docker rm shipyard-rethinkdb

docker stop shipyard-discovery
docker rm shipyard-discovery

docker stop shipyard-swarm-manager
docker rm shipyard-swarm-manager

docker stop shipyard-swarm-agent
docker rm shipyard-swarm-agent

docker stop shipyard-controller
docker rm shipyard-controller


docker stop shipyard-proxy
docker rm shipyard-proxy

#docker stop rancher-carina
#docker rm rancher-carina
#docker run -d --name rancher-carina --restart=always -p 8080:8080 rancher/server

DISCOVERY_PORT=4001
DISCOVERY_PEER_PORT=7001
SWARM_PORT=2375 #3375




TLS_OPTS="-e SSL_CA=ca.pem -e SSL_CERT=cert.pem -e SSL_KEY=key.pem -e SSL_SKIP_VERIFY=0"
DOCKER_OPTS="-H=$SWARM_IP:42376  --tlsverify --tlscacert=./ca.pem --tlscert=./server.pem --tlskey=./ca-key.pem"



#Datastore
echo Datastore

docker run \
    -ti \
    -d \
    --restart=always \
    --name shipyard-rethinkdb \
    rethinkdb


#docker run --net=host --rm racknet/ip public

#Discovery
echo Discovery:
docker run \
    -ti \
    -d \
    -p $DISCOVERY_PORT:$DISCOVERY_PORT \
    -p $DISCOVERY_PEER_PORT:$DISCOVERY_PEER_PORT \
    --restart=always \
    --name shipyard-discovery \
    microbox/etcd -name discovery -addr=`docker run --net=host --rm racknet/ip public`:$DISCOVERY_PORT

#proxy
#See the Dockerfile & run.sh in another gist below.
#docker run -ti -d --restart=always --name shipyard-proxy -e SSL_CA=ca.pem -e SSL_CERT=cert.pem -e SSL_KEY=key.pem ehazlett/docker-proxy:latest
echo Proxy:
#docker build -t usernamehere/shipyard-proxy ./proxy

docker --tlscacert=ca.pem --tlscert=cert.pem  --tlskey=key.pem -H=$SWARM_IP:42376 build -t usernamehere/shipyard-proxy ./proxy
docker --tlscacert=ca.pem --tlscert=cert.pem  --tlskey=key.pem -H=$SWARM_IP:42376 run -ti -d --restart=always --name shipyard-proxy -p 2375:2375 usernamehere/shipyard-proxy

#Swarm Manager
echo Swarm Manager:
    docker run \
        -ti \
        -d \
        --restart=always \
        --name shipyard-swarm-manager \
        swarm:latest \
        manage --host tcp://0.0.0.0:$SWARM_PORT etcd://`docker run --net=host --rm racknet/ip public`:$DISCOVERY_PORT




        docker run \
            -ti \
            -d \
            --restart=always \
            --name shipyard-swarm-agent \
            -e SSL_CA=ca.pem -e SSL_CERT=cert.pem -e SSL_KEY=key.pem -e SSL_SKIP_VERIFY=1 \
            swarm:latest \
            join --addr `docker run --net=host --rm racknet/ip public`:$SWARM_PORT etcd://`docker run --net=host --rm racknet/ip public`:$DISCOVERY_PORT

        docker run \
        -ti \
        -d \
        --restart=always \
        --name shipyard-controller \
        --link shipyard-rethinkdb:rethinkdb \
        --link shipyard-swarm-manager:swarm \
        -p 8080:8080 \
        shipyard/shipyard:latest \
        server \
        -d tcp://swarm:$SWARM_PORT
        #-d tcp://swarm:$SWARM_PORT

echo Please wait
sleep 4
sh ./logs.sh
