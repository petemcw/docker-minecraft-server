FROM linuxserver/baseimage
MAINTAINER Pete McWilliams <petemcw@gmail.com>

ENV APTLIST="libmozjs-24-bin openjdk-7-jre-headless wget"
ENV MINECRAFT_HOME="/src" \
    JAVA_OPTS="-server -Xmx1024M -Xms1024M -XX:MaxPermSize=256m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC" \
    VERSION="latest" \
    MOTD="Docker Powered Minecraft\!" \
    LEVEL_SEED="" \
    LEVEL_NAME="world" \
    LEVEL_TYPE="DEFAULT" \
    PVP="true" \
    DIFFICULTY="2" \
    GAMEMODE="0" \
    MAX_TICK_TIME="-1"

# install/update packages
RUN apt-get -yqq update && \
    apt-get -yqq install $APTLIST && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install jsawk
RUN update-alternatives --install /usr/bin/js js /usr/bin/js24 100
RUN curl -sL https://raw.githubusercontent.com/micha/jsawk/master/jsawk -o /usr/bin/jsawk && \
    chmod +x /usr/bin/jsawk

# add scripts
COPY init/ /etc/my_init.d/
COPY services/ /etc/service/
COPY defaults/ /tmp
RUN  chmod +x /etc/service/*/run /etc/my_init.d/*.sh

# exports
EXPOSE  25565
VOLUME  [ "/src" ]
WORKDIR /src
