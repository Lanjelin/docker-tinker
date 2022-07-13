[OpenAudible](https://github.com/openaudible/openaudible_docker) built using [baseimage-rdesktop-web](https://github.com/linuxserver/docker-baseimage-rdesktop-web/) instead of the full [webtop](https://github.com/linuxserver/docker-webtop) as the official image uses.

Only downside I've found; if you close the application window within the browser, the container needs to be restarted to pull it back up (as there's no visible desktop).

Built with a script in `/etc/cont-init.d/` to install OpenAudible when the container is started the first time.
Deleting/remaking the container will then install the latest version of OpenAudible (no need to remake image).

**docker-compose**, with traefik reverse proxy and authelia authentication 
```yaml
version: "3.8"
services:
  openaudible:
    container_name: openaudible
    image: lanjelin/openaudible:latest
    ports:
      - "3000:3000"
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./config/openaudible:/config
    # Following is a working traefik config with authelia authentication.
    # Skip the next lines if you're not using traefik
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.openaudible.entrypoints=websecure"
      - "traefik.http.routers.openaudible.rule=Host(`openaudible.example.com`)"
      - "traefik.http.routers.openaudible.middlewares=authelia@docker"
      - "traefik.http.routers.openaudible.service=openaudible"
      - "traefik.http.services.openaudible.loadbalancer.server.port=3000"
      - "traefik.http.services.openaudible.loadbalancer.server.scheme=http"
    networks:
      - traefik

networks:
  traefik:
    external: true
```

**58-openaudibleinstall**
```bash
#!/usr/bin/with-contenv bash

# install OpenAudible on firstrun
[[ ! -f /usr/local/OpenAudible/OpenAudible ]] && \
    echo "Downloading OpenAudible installer.." && \
    wget -q https://openaudible.org/latest/OpenAudible_x86_64.sh -O openaudible_installer.sh  && \
    sh ./openaudible_installer.sh -q -overwrite -dir /usr/local/OpenAudible && \
    rm openaudible_installer.sh
```

**Dockerfile**
```dockerfile
FROM ghcr.io/linuxserver/baseimage-rdesktop-web:bionic
ENV TITLE=OpenAudible
RUN echo "Installing dependencies" && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libgtk-3-bin ca-certificates wget libswt-webkit-gtk-4-jni xdg-utils libnss3-dev && \
    wget -q https://raw.githubusercontent.com/Lanjelin/docker-tinker/main/openaudible/58-openaudibleinstall -O /etc/cont-init.d/58-openaudibleinstall && \
    echo "OpenAudible" > /defaults/autostart && \
    echo "Cleaning up" && \
    apt remove -y xfce4-panel firefox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 3000
#VOLUME /config/OpenAudible - skipping this as baseimage already got VOLUME /config
```
