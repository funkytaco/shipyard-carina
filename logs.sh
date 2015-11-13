#!/bin/bash
echo ---------------------------------
echo shipyard-swarm-agent.... [ `docker port shipyard-swarm-agent` ]
echo -\>
docker logs shipyard-swarm-agent
echo ---------------------------------
echo shipyard-discovery... [`docker port shipyard-discovery`]
echo -\>
docker logs shipyard-discovery
echo ---------------------------------
echo shipyard-swarm-manager... [`docker port shipyard-swarm-manager`]
echo -\>
docker logs shipyard-swarm-manager
echo ---------------------------------
echo shipyard-proxy... [ `docker port shipyard-proxy` ]
echo -\>
docker logs shipyard-proxy
echo ---------------------------------
echo shipyard-controller... [ `docker port shipyard-controller` ]
echo -\>
docker logs shipyard-controller
