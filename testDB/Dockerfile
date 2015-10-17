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
FROM docker.blinkboxmusic.com/blinkboxmusic/det_postgresql
MAINTAINER Gus Robinson  <gus@blinkbox.com>

USER postgres

COPY ./artifacts/latest.sqlbin      /latest.sql_bin
COPY ./artifacts/latest_rec.sqlbin  /latest_rec.sql_bin

RUN /etc/init.d/postgresql start && \
    pg_restore -C -U postgres -d postgres /latest.sql_bin  && \
    pg_restore -C -U postgres -d postgres /latest_rec.sql_bin

USER root    
RUN rm /latest.sql_bin && \
    rm /latest_rec.sql_bin

EXPOSE 5432

USER postgres

CMD ["/usr/lib/postgresql/9.3/bin/postgres", "-D", "/var/lib/postgresql/9.3/main", "-c", "config_file=/etc/postgresql/9.3/main/postgresql.conf"]
