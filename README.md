Docker image for Left 4 Dead 2 server
=====================================

[Forked from sunbowworl](https://github.com/sunbowworld/docker-left4dead2server)

Adaptions:

 * Use i386/debian-buster instead of outdated stretch
 * Use some ideas from other Dockerfiles [1](https://github.com/sequel7/docker_steamcmd) [2](https://github.com/sequel7/docker_l4d2)
 * More environment variables, and put them into .env file

# Usage

Copy .env.example to .env and adapt the values!

```bash
docker build -t lef4dead2server .
docker run --rm --env-file .env -p 27015:27015 -p 27015:27015/udp left4dead2server
```

# References

* [Install SteamCMD for a Steam Game Server](https://www.linode.com/docs/game-servers/install-steamcmd-for-a-steam-game-server/)
* [Left 4 Dead 2 Multiplayer Server Installation](https://www.linode.com/docs/game-servers/left-4-dead-2-multiplayer-server-installation/)
