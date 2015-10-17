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

#apt-get update     # Java would not install without this line
#apt-get -qqy install oracle-java8-jdk    # install java
#apt-get -qqy install git       # install git ( quite a few java build processes require git)

# Do it all in a single step
RUN apt-get update && \
    apt-get -qqy install oracle-java8-jdk && \
    apt-get -qqy install git


