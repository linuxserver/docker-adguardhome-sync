# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.18

ARG BUILD_DATE
ARG VERSION
ARG ADGUARDHOMESYNC_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

ENV \
  HOME=/config

RUN \
  apk add --update --no-cache curl && \
  mkdir -p /app/adguardhome-sync && \
  if [ -z ${ADGUARDHOMESYNC_RELEASE+x} ]; then \
    ADGUARDHOMESYNC_RELEASE=$(curl -sX GET "https://api.github.com/repos/bakito/adguardhome-sync/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  echo "*** Installing AdGuardHome Sync ***" && \
  curl -o \
    /tmp/adguardhomesync.tar.gz -L \
    "https://github.com/bakito/adguardhome-sync/releases/download/${ADGUARDHOMESYNC_RELEASE}/adguardhome-sync_${ADGUARDHOMESYNC_RELEASE#v}_linux_amd64.tar.gz" && \
  tar xzf \
    /tmp/adguardhomesync.tar.gz -C \
    /app/adguardhome-sync/ && \
  echo "*** Cleaning Up ***" && \
  rm /tmp/adguardhomesync.tar.gz

COPY /root donate.txt /

EXPOSE 8080

VOLUME /config
