#
# To create a fresh docker image run this command
# docker build -t docker.blinkboxmusic.coml/blinkboxmusic/blah .
# # Dont forget the dot at the end !
#
# To push the image to the we7 registry....
# docker push docker.blinkboxmusic.com/blinkboxmusic/blah
#
# YOU DO NOT HAVE TO DO THE ABOVE UNLESS THE registry image needs updating
#
FROM docker.blinkboxmusic.com/blinkboxmusic/debian_java8
MAINTAINER Gus Robinson  <gus@blinkbox.com>

RUN apt-get update
RUN apt-get install -qqy git


COPY artifacts/tomcat_keystore /usr/share/bbm-radio-site/tomcat_keystore

COPY files/radio-site-log4j.xml  /etc/bbm/radio-site-log4j.xml
COPY files/radio-site-tomcat.yml /etc/bbm/radio-site-tomcat.yml

COPY files/local.props /etc/we7/local.props

COPY files/gradle.properties /root/.gradle/gradle.properties

COPY files/start-radio-site.sh /start-radio-site.sh
COPY files/create-radio-site.sh /create-radio-site.sh
RUN chmod +x /start-radio-site.sh
RUN chmod +x /create-radio-site.sh

