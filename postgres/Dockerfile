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
FROM docker.blinkboxmusic.com/blinkboxmusic/debian:
MAINTAINER Gus Robinson  <gus@blinkbox.com>

RUN apt-get -qq update
RUN apt-get -qqy install apt-utils
RUN apt-get -qqy install net-tools nano

RUN echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    apt-get install -y locales -qq && \
    locale-gen  && \
    dpkg-reconfigure locales && \
    locale -a && \
    /usr/sbin/update-locale LANG=en_GB.UTF-8

ENV LANG en_GB.UTF-8
ENV LANGUAGE en_GB:en
ENV LC_ALL en_GB.UTF-8

# Install Postgresql 9.3
RUN apt-get -qqy install postgresql-9.3
ADD ./pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
ADD ./postgresql.conf /etc/postgresql/9.3/main/postgresql.conf

EXPOSE 5432

# switch user as postgres should not be run as root
USER postgres

# Create a docker user
#RUN    /etc/init.d/postgresql start &&\
#    psql --command "CREATE USER docker WITH SUPERUSER PASSWORD 'docker';" &&\
#    createdb -O docker docker


CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
