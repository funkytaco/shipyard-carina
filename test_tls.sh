#!/bin/bash
if [ -s carina_swarm_ip.env ];
then
    source carina_swarm_ip.env
    if [ -z  "$CARINA_SWARM_IP" ];
        then
        echo "SWARM IP NOT SET"
        exit 1
    else
        echo "TESTING TLS FOR SWARM IP: $CARINA_SWARM_IP"
        docker --tlsverify --tlscacert=ca.pem --tlscert=cert.pem  --tlskey=key.pem -H=$CARINA_SWARM_IP:42376 version
    fi
else
    echo "unable to test TLS support"
fi
