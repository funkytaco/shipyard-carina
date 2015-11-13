#!/bin/bash

if [ -s carina_swarm_ip.env ];
then
    source carina_swarm_ip.env
    if [ -z  "$CARINA_SWARM_IP" ];
        then
        echo "SWARM IP NOT SET"
        exit 1
    else
        echo "TESTING SHIPYARD TLS FOR SWARM IP: $CARINA_SWARM_IP"
        curl -i -v --cacert ca.pem -E cert.pem  --key key.pem https://$CARINA_SWARM_IP:42376
    fi
else
    echo "unable to test TLS support"
fi
