FROM ubuntu:xenial
LABEL maintainer="itrushchenko@anchorfree.com"

ENV VERSION=0.40.0-1

RUN env

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget apt-transport-https
COPY mcrouter.list /etc/apt/sources.list.d/
RUN wget -O - https://facebook.github.io/mcrouter/debrepo/xenial/PUBLIC.KEY  | apt-key add && \
		apt-get update -y && \
		apt-get install -y mcrouter=$VERSION && \
		apt-get clean

ENTRYPOINT ["mcrouter"]
