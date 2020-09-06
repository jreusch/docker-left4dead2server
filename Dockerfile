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

RUN mkdir -p /opt/steamcmd &&\
    mkdir /opt/server &&\
    chown -R steam /opt/steamcmd &&\
    chown -R steam /opt/server

# SteamCMD should not be used as root, here we set up user and variables
USER steam
WORKDIR /opt/steamcmd

# Downloading SteamCMD and make the Steam directory owned by the steam user
# normally the url would be http://media.steampowered.com/installer/steamcmd_linux.tar.gz
# but unencrypted traffic is evil and media.steampowered.com sadly does not have a
# valid certificate as of now...
RUN curl -s https://steamcdn-a.akamaihd.net/installer/steamcmd_linux.tar.gz | tar -vxz

RUN ./steamcmd.sh +login anonymous +force_install_dir /opt/server/ +app_update 222860 validate +quit

COPY --chown=steam server.cfg.tpl /home/steam/server.cfg.tpl
COPY --chown=steam entrypoint.sh /home/steam/entrypoint.sh
COPY --chown=steam random_map.sh /home/steam/random_map.sh

EXPOSE 27015
EXPOSE 27015/udp

ENV SV_HOSTNAME "L4D2 Server"
ENV SV_RCON_PASSWORD "rconpassword"
ENV SV_STEAMGROUP=0
ENV SV_STEAMGROUP_EXCLUSIVE=0

ENTRYPOINT ["/bin/bash", "/home/steam/entrypoint.sh"]
