FROM i386/debian:buster

# create user for steam
RUN adduser \
	--home /home/steam \
	--disabled-password \
	--shell /bin/bash \
	--gecos "user for running steam" \
	--quiet \
	steam

ENV DEBIAN_FRONTEND noninteractive

# install dependencies
RUN apt-get update && \
    apt-get install -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Downloading SteamCMD and make the Steam directory owned by the steam user
RUN mkdir -p /opt/steamcmd &&\
    mkdir /opt/server &&\
    cd /opt/steamcmd &&\
    curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -vxz &&\
    chown -R steam /opt/steamcmd &&\
    chown -R steam /opt/server

# SteamCMD should not be used as root, here we set up user and variables
USER steam
WORKDIR /opt/steamcmd

ENV SV_HOSTNAME "L4D2 Server"
ENV SV_RCON_PASSWORD "rconpassword"

RUN ./steamcmd.sh +login anonymous +force_install_dir /opt/server/ +app_update 222860 validate +quit

COPY --chown=steam server.cfg.tpl /home/steam/server.cfg.tpl
COPY --chown=steam entrypoint.sh /home/steam/entrypoint.sh
COPY --chown=steam random_map.sh /home/steam/random_map.sh

EXPOSE 27015
EXPOSE 27015/udp

ENTRYPOINT ["/bin/bash", "/home/steam/entrypoint.sh"]
