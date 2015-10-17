#
# To create a fresh docker image run this command
# docker build -t docker.blinkboxmusic.com/blinkboxmusic/blah .
# # Dont forget the dot at the end !
#
# To push the image to the we7 registry....
# docker push docker.blinkboxmusic.com/blinkboxmusic/blah
#
# YOU DO NOT HAVE TO DO THE ABOVE UNLESS THE registry image needs updating
#
FROM docker.blinkboxmusic.com/blinkboxmusic/debian:wheezy
MAINTAINER Gus Robinson  <gus@blinkbox.com>

RUN apt-get update && \
    apt-get install -qqy memcached

CMD ["/usr/bin/memcached -m 64 -p 11212 -u nobody -l 127.0.0.1"]

