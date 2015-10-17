#!/bin/bash

if [ "$1" == "" ] ; then
  echo "lkjdlfksjflksdfjlj"
  dbserver="podalirius.we7.local"
  dbport="5432"
  apiserver="podalirius.we7.local"
  apiport="8080"
  apisecport="8443"
  memcache="localhost:11211"
else
  dbserver=$1
  dbport=$2
  apiserver=$3
  apiport=$4
  apisecport=$5
  memcache=$6
#  installrec=$7
fi

echo "10.0.2.15 dockerVM" >> /etc/hosts


echo "${dbserver} ${dbport} ${apiserver} ${apiport} ${apisecport}"
#${installrec}

cfgfile="/etc/we7/recommendations/local-we7recommend.cfg"


eval "sed -i 's/DOCKER_DB_SERVER_NAME/${dbserver}/g' ${cfgfile}"
eval "sed -i 's/DOCKER_DB_SERVER_PORT/${dbport}/g' ${cfgfile}"
eval "sed -i 's/DOCKER_API_SERVER_NAME/${apiserver}/g' ${cfgfile}"
eval "sed -i 's/DOCKER_API_SERVER_PORT/${apiport}/g' ${cfgfile}"
eval "sed -i 's/DOCKER_API_SERVER_SECPORT/${apisecport}/g' ${cfgfile}"
eval "sed -i 's/DOCKER_MEMCACHE_NAME_AND_PORT/${memcache}/g' ${cfgfile}"

echo "DONE" >> /tweek.log

if [ "$installrec" == "1" ] ; then
  touch /var/log/rec.log
  chmod 666 /var/log/rec.log
  apt-get install -qqy recommendations-we7
  sleep 5
else
  service lighttpd start
  tail -F /var/log/rec.log
fi
 


