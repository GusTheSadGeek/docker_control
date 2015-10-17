#
# To create a fresh docker image run this command
# docker build -t docker.blinkboxmusic.com/blinkboxmusic/blah .
# # Dont forget the dot at the end !
#
# To push the image to the bbm registry....
# docker push docker.blinkboxmusic.com/blinkboxmusic/blah
#
# YOU DO NOT HAVE TO DO THE ABOVE UNLESS THE registry image needs updating
#
FROM docker.blinkboxmusic.com/blinkboxmusic/debian:wheezy
MAINTAINER Gus Robinson  <gus@blinkbox.com>

COPY ./files/index.sh                       /index.sh
COPY ./testdb-creator/                      /testdb-creator/

RUN apt-get update
RUN apt-get -yqq install python2.7  

RUN cd /testdb-creator && \
    apt-get install -y curl && \
    apt-get install -y python-psycopg2 && \
    apt-get install -y python-pip

RUN cd /testdb-creator && \
    pip install virtualenv  && \
    pip install psycopg2 && \
    virtualenv venv && \
    . venv/bin/activate && \
    export PYTHONPATH=/vagrant/testdb-creator/venv:/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages  && \
    pip install requests


