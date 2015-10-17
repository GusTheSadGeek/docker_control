#
# To create a fresh docker image run this command
# docker build -t docker.blinkboxmusic.com/blinkboxmusic/blah .
# # Dont forget the dot at the end !
#
# To push the image to the we7 registry....
# docker push docker.blinkboxmusic.coml/blinkboxmusic/blah
#
# YOU DO NOT HAVE TO DO THE ABOVE UNLESS THE registry image needs updating
#
FROM docker.blinkboxmusic.com/blinkboxmusic/debian:wheezy
MAINTAINER Gus Robinson  <gus@blinkbox.com>

RUN apt-get update
RUN apt-get install -qqy python2.7 \
                         lighttpd \
                         pythoncore-we7


RUN mkdir -p /etc/we7/recommendations && touch /etc/we7/recommendations/local-we7recommend.cfg

COPY ./files/lighttpd.conf             /etc/lighttpd/lighttpd.conf
COPY ./files/000-mod_fastcgi.conf      /etc/lighttpd/conf-available/000-mod_fastcgi.conf
COPY ./files/recommendations.conf      /etc/lighttpd/conf-available/recommendations.conf
COPY ./files/local-we7recommend.cfg    /etc/we7/recommendations/local-we7recommend.cfg
COPY ./files/start-recommendations.sh  start-recommendations.sh


RUN chmod +x start-recommendations.sh && \
    cd /etc/lighttpd/conf-enabled && \
    ln -s /etc/lighttpd/conf-available/recommendations.conf && \
    ln -s /etc/lighttpd/conf-available/000-mod_fastcgi.conf && \
    touch /var/log/rec.log && \
    chmod 666 /var/log/rec.log

#RUN apt-get install -qqy pythoncore-we7

#EXPOSE 81
EXPOSE 82


RUN apt-get update
RUN apt-get install -qqy recommendations-we7

CMD ["service memcached start && service lighttpd start && tail -F /var/log/rec.log"]
