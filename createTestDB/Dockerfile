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
FROM docker.blinkboxmusic.com/blinkboxmusic/debian_java8
MAINTAINER Gus Robinson  <gus@blinkbox.com>

RUN apt-get update

COPY ./testdb-creator/                      /testdb-creator/
COPY ./track-versions/                      /track-versions/
COPY ./artifacts/local-we7trackversion.cfg  /etc/we7/local-we7trackversion.cfg
COPY ./artifacts/local-testdb.cfg           /testdb-creator/local-testdb.cfg
COPY ./artifacts/mass-upload-client-1.0.jar /testdb-creator/build/libs/mass-upload-client-1.0.jar
COPY ./artifacts/api_keystore               /testdb-creator/api_keystore
COPY ./files/backupdb.sh                    /backupdb.sh

RUN apt-get -yqq install python2.7  

RUN cd /track-versions && \
    /usr/bin/python2.7 ./setup.py build && \
    /usr/bin/python2.7 ./setup.py install

RUN cd /testdb-creator && \
    apt-get install -y python-pip && \
    apt-get install -y python-psycopg2 && \
    apt-get install -y libpq-dev && \
    apt-get install -y python-dev  && \
    apt-get install -y pythoncore-we7 && \
    apt-get install -y curl && \
    apt-get install -y postgresql-client-9.3
    
RUN cd /testdb-creator && \
    pip install virtualenv  && \
    virtualenv venv && \
    . venv/bin/activate && \
    export PYTHONPATH=/vagrant/testdb-creator/venv:/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages  && \
    pip install psycopg2 && \
    pip install requests && \
    ./stageXX_create_mass_upload_xml_files.py
    
#RUN  export PYTHONPATH=/vagrant/testdb-creator/venv:/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages  && \
#    pip install psycopg2 && \
#    pip install requests && \
#    cd /testdb-creator  && \
#    . venv/bin/activate

#RUN    ./stageXX_create_mass_upload_xml_files.py
#RUN     ./main.py 1 1
#RUN     ./main.py 6 6

#RUN     sudo /etc/init.d/memcached restart
#RUN     sleep 30
#RUN     ./main.py 1 1
#RUN     ./main.py 3


#export PYTHONPATH=/vagrant/testdb-creator/venv:/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages;. venv/bin/activate
