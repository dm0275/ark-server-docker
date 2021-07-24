FROM ubuntu:18.04

#-------------------------------------------------------------------------------
#  Runtime Arguments (default values can be overwritten)
#-------------------------------------------------------------------------------
ENV SERVER_MAP=TheIsland \
    SERVER_NAME=ArkServerDM \
    JOIN_PASSWORD=changeme123 \
    ADMIN_PASSWORD=changeme123

RUN echo "fs.file-max=100000" >> /etc/sysctl.conf \
  && sysctl -p /etc/sysctl.conf \
  && echo "*               soft    nofile          1000000" >> /etc/security/limits.conf \
  && echo "*               hard    nofile          1000000" >> /etc/security/limits.conf \
  && echo "session required pam_limits.so" >> /etc/pam.d/common-session

RUN apt update && apt install software-properties-common -y \
  && add-apt-repository multiverse \
  && dpkg --add-architecture i386 \
  &&apt update \
  && apt install lib32gcc1 libsdl2-2.0-0:i386 curl -y \
  && useradd -m arkuser \
  && cd /home/arkuser

USER arkuser

WORKDIR /home/arkuser

RUN curl -sL -o /tmp/steamcmd_linux.tar.gz "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" \
  && tar xf /tmp/steamcmd_linux.tar.gz -C /home/arkuser/ \
  && mkdir /home/arkuser/ark_server \
  && /home/arkuser/steamcmd.sh +login anonymous +force_install_dir /home/arkuser/ark_server +app_update 376030 +quit \
  && mkdir -p /home/arkuser/ark_server/ShooterGame/Saved

COPY server_start.sh /home/arkuser

ENTRYPOINT ["/home/arkuser/server_start.sh"]