#!/bin/bash

envsubst < /home/steam/server.cfg.tpl > /home/steam/server.cfg

/home/appuser/l4d2server/srcds_run \
  -console \
  -game left4dead2 \
  -strictportbind \
  -ip 0.0.0.0 \
  -port 27015 \
  +maxplayers 12 \
  +exec /home/steam/server.cfg \
  +map $(/home/steam/random_map.sh)
