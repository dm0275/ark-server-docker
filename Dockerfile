FROM ubuntu:18.04

#-------------------------------------------------------------------------------
#  Environment Vars
#-------------------------------------------------------------------------------
ENV STEAMCMD_HOME=/home/arkuser/bin
ENV ARK_BIN_HOME=/home/arkuser/ark_server/ShooterGame/Binaries/Linux
ENV PATH=$STEAMCMD_HOME:$ARK_BIN_HOME:$PATH

RUN echo "fs.file-max=100000" >> /etc/sysctl.conf \
  && sysctl -p /etc/sysctl.conf \
  && echo "*               soft    nofile          1000000" >> /etc/security/limits.conf \
  && echo "*               hard    nofile          1000000" >> /etc/security/limits.conf \
  && echo "session required pam_limits.so" >> /etc/pam.d/common-session

RUN apt update && apt install software-properties-common -y \
  && add-apt-repository multiverse \
  && dpkg --add-architecture i386 \
  && apt update \
  && apt install lib32gcc1 libsdl2-2.0-0:i386 curl -y \
  && useradd -m arkuser \
  && cd /home/arkuser \
  && mkdir $STEAMCMD_HOME \
  && chown -R arkuser:arkuser $STEAMCMD_HOME

USER arkuser

WORKDIR /home/arkuser

RUN curl -sL -o /tmp/steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
  && tar xf /tmp/steamcmd_linux.tar.gz -C $STEAMCMD_HOME \
  && mkdir /home/arkuser/ark_server \
  && steamcmd.sh +login anonymous +force_install_dir /home/arkuser/ark_server +app_update 376030 +quit \
  && mkdir -p /home/arkuser/ark_server/ShooterGame/Saved

COPY server_start.sh /home/arkuser

ENTRYPOINT ["/home/arkuser/server_start.sh"]