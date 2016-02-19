# petemcw/docker-minecraft-server

Because its fun and my kids love it, this is a Docker image for a vanilla Minecraft server.

![](https://raw.githubusercontent.com/petemcw/docker-templates/master/petemcw/img/minecraft-banner.png)

## Usage

To quickly get the latest stable version of Minecraft up and running, the following will get you started:

```
docker run -d --name=minecraft_server \
    -p 25556:25556 \
    -v /src \
    -e PUID=<uid> \
    -e PGID=<gid> \
    -e EULA=true \
    -e DEFAULT_OP=<name> \
    petemcw/docker-minecraft-server
```

### Required Startup Variables

Mojang requires you to agree to their [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). If you don't pass an acceptance variable the container will not start.

I am also requiring at least a single administrator to be specified. You can pass in a single username or a comma-separated list.

```bash
DEFAULT_OP=petemcw,<some_other_admin>
```

## Versions

The container will default to the latest stable release. You can change the version used by specifying one of three values:

* `latest` -- most recent stable release
* `snapshot` -- most recent release
* `1.x.x` -- specific version number, such as `1.8.9`

For example to run the latest, bleeding-edge version:

```bash
docker run -d -e VERSION=snapshot ...
```

## Server Configuration (Environment Variables)

The image uses environment variables to alter the configuration of the Minecraft server and Java settings. The most common settings are highlighted below but any of the options from `server.properties` can be adjusted.

### EULA

The variable `EULA` is required when creating a new container. Mojang requires that you agree before Minecraft can be run.

### Default OP

The variable `DEFAULT_OP` is required when creating a new container. Any usernames specified in the variable will be added to the `ops.json` file.

### Java Options

You can adjust the JVM settings by altering what is defined in the `JAVA_OPS` variable. This is useful for settings things like Java's memory limit.

### Minecraft Home

The default location for `MINECRAFT_HOME` is `/src`, which is also a volume. All Minecraft related artifacts go here. To add mods, backup your world data, or make other changes to your server you must connect to your server container and make changes in this directory.

### Message of The Day

You can adjust the message that is shown below each server entry in the Minecraft UI by changing the `MOTD` variable.

To use spaces in the message you will need to quote the whole variable like so:

```bash
docker run -d -e "MOTD=Best Server Ever"
```

### World Name

You can switch between worlds or run multiple servers with different worlds by changing the value of the `LEVEL_NAME` variable.

### Seed

You can create your Minecraft world using a specific seed by passing the value within the `LEVEL_SEED` variable.

A few cool options are:

* `4031384495743822299`
* `69160882195`

### Difficulty

This image defaults the Minecraft difficulty to normal. You can change the difficulty by switching the `DIFFICULTY` variable. The possible options are:

* `0` -- Peaceful
* `1` -- Easy
* `2` -- Normal
* `3` -- Hard

### Game Mode

The default game mode for Minecraft is survival. You can change the mode by altering the `GAMEMODE` variable. The possible options are:

* `0` -- Survival
* `1` -- Creative
* `2` -- Adventure
* `3` -- Spectator (version 1.8 or later)

### PVP

The default setting is for the player-vs-player (PVP) mode to be enabled. You can disable this functionality by setting the `PVP` variable to `false`.

### `server.properties`

For reference, here is a list of the variables that can be set for use with generating a `server.properties` file:

* ALLOW_FLIGHT
* ALLOW_NETHER
* ANNOUNCE_PLAYER_ACHIEVEMENTS
* DIFFICULTY
* ENABLE_COMMAND_BLOCK
* ENABLE_QUERY
* ENABLE_RCON
* FORCE_GAMEMODE
* GAMEMODE
* GENERATE_STRUCTURES
* GENERATE_SETTINGS
* LEVEL_NAME
* LEVEL_SEED
* LEVEL_TYPE
* MAX_BUILD_HEIGHT
* MAX_PLAYER
* MAX_TICK_TIME
* MAX_WORLD_SIZE
* MOTD
* NETWORK_COMPRESSION_THRESHOLD
* ONLINE_MODE
* OP_PERMISSION_LEVEL
* PLAYER_IDLE_TIMEOUT
* PVP
* RESOURCE_PACK
* RESOURCE_PACK_SHA1
* SERVER_IP
* SERVER_PORT
* SNOOPER_ENABLED
* SPAWN_ANIMALS
* SPAWN_MONSTERS
* SPAWN_NPCS
* USE_NATIVE_TRANSPORT
* VIEW_DISTANCE
* WHITE_LIST

## Data Volume

This image has a single volume defined, `/src`. This volume contains all the Minecraft server and world data. You can learn more about how to [manage data within a volume at Docker](https://docs.docker.com/engine/userguide/containers/dockervolumes/).

## Docker Compose

This is the preferred way for managing your containers boots your Minecraft server with a data volume container to make sure your data is persisted.

Assuming you have Docker Compose installed, you need to have a `docker-compose.yml` file with your container details:

```bash
minecraft:
  image: petemcw/minecraft-server
  ports:
    - "25565:25565"
  volumes_from:
    - minecraft_data
  restart: always
  environment:
    - ADVANCED_DISABLEUPDATES=true
    - PUID=501
    - PGID=20
    - EULA=true
    - DEFAULT_OP=petemcw

minecraft_data:
  image: tianon/true
  volumes:
    - /src
```

Using the example above, to launch your Minecraft server and persist your data:

```bash
docker-compose up -d minecraft
```
