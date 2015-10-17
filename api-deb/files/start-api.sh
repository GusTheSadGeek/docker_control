#!/bin/bash

echo "======================================="
echo "Checking env vars"

if [ "$API_HOST" == "" ] ; then
  echo "API_HOST not defined"
  exit 1
fi
if [ "$API_PORT" == "" ] ; then
  echo "API_PORT not defined"
  exit 2
fi
if [ "$API_SEC_PORT" == "" ] ; then
  echo "API_SEC_PORT not defined"
  exit 3
fi
if [ "$REC_PORT" == "" ] ; then
  echo "REC_PORT not defined"
  exit 4
fi
if [ "$REC_HOST" == "" ] ; then
  echo "REC_HOST not defined"
  exit 5
fi
if [ "$DB_PORT" == "" ] ; then
  echo "DB_PORT not defined"
  exit 6
fi
if [ "$DB_HOST" == "" ] ; then
  echo "DB_HOST not defined"
  exit 7
fi
if [ "$SOLR_PORT" == "" ] ; then
  echo "SOLR_PORT not defined"
  exit 8
fi
if [ "$SOLR_HOST" == "" ] ; then
  echo "SOLR_HOST not defined"
  exit 9
fi
if [ "$MEMCACHE_PORT" == "" ] ; then
  echo "MEMCACHE_PORT not defined"
  exit 10
fi
if [ "$MEMCACHE_HOST" == "" ] ; then
  echo "MEMCACHE_HOST not defined"
  exit 11
fi

recserver="${REC_HOST}:${REC_PORT}"
dbserver="${DB_HOST}\\\:${DB_PORT}"
solrhost="${SOLR_HOST}:${SOLR_PORT}"

old_api=8080
old_apis=8443

api_tomcat_config_file="/etc/bbm/mediagraft-tomcat.yml"
api_config_file="/etc/bbm/mediagraft.properties"

#haproxy_cfg_file="/etc/haproxy/haproxy.cfg"

echo "API   PORTS  ${old_api},${old_apis}  ==>  ${API_PORT}, ${API_SEC_PORT}" >> /tweek.log

env >> /tweek.log

echo "10.0.2.15 dockerVM" >> /etc/hosts

cp ${api_config_file} /api.config

#if [ -e ${haproxy_cfg_file} ] ; then
#  eval "sed -i 's/@APIPORT@/${HA_API_PORT}/g' ${haproxy_cfg_file}"
#  eval "sed -i 's/@APISECPORT@/${HA_API_SEC_PORT}/g' ${haproxy_cfg_file}"
#fi

echo "======================================="
echo "Configuring ${api_tomcat_config_file}"

if [ -e ${api_tomcat_config_file} ] ; then
  eval "sed -i 's/@http_port@/${API_PORT}/g' ${api_tomcat_config_file}"
  eval "sed -i 's/@https_port@/${API_SEC_PORT}/g' ${api_tomcat_config_file}"
#  eval "sed -i 's/ssl: false/ssl: true/g' ${api_tomcat_config_file}"
#  echo "  keystore: /tomcat_keystore" >> ${api_tomcat_config_file}
fi

echo "======================================="
echo "Configuring ${api_config_file}"


eval "sed -i 's|application.secure.url=.*|application.secure.url=https://localhost:${API_SEC_PORT}|g' ${api_config_file}"
eval "sed -i 's|application.url=.*|application.url=http://localhost:${API_PORT}|g' ${api_config_file}"


eval "sed -i '|expletives.filename=.*|expletives.filename=http://localhost:${API_SEC_PORT}|g' ${api_config_file}"


eval "sed -i 's|=${old_api}|=${API_PORT}|g' ${api_config_file}"
eval "sed -i 's|=${old_apis}|=${API_SEC_PORT}|g' ${api_config_file}"


# Fudge the email server settings...
eval "sed -i 's|email.host=.*|email.host=zeus.we7.local|g' ${api_config_file}"
eval "sed -i 's|email.service.mq.name=.*|email.service.mq.name=|g' ${api_config_file}"


# prevent MOGFS uploads
eval "sed -i 's|mp3.dest.dir=.*|mp3.dest.dir=/tmp/mp3s_dest|g' ${api_config_file}"
eval "sed -i 's|mp3.upload.dir=.*|mp3.upload.dir=/tmp/mp3s_upload|g' ${api_config_file}"


#jdbc.url=jdbc\:we7\:postgresql\://localhost\:5432/podsplice

#eval "sed -i 's/jdbc.hostname=localhost/jdbc.hostname=db/g' ${api_config_file}"

eval "sed -i 's|localhost\\\:5432|${dbserver}|g' ${api_config_file}"


eval "sed -i 's|solr.localhost\\\:5432|${dbserver}|g' ${api_config_file}"


#radio.recommendation.url=http://localhost:82
eval "sed -i 's|radio.recommendation.url=.*|radio.recommendation.url=http:\/\/${recserver}|g' ${api_config_file}"

eval "sed -i 's|track.recommendation.service.url=.*|track.recommendation.service.url=http:\/\/${recserver}|g'  ${api_config_file}"

eval "sed -i 's|artist.recommendation.service.url=.*artist.recommendation.service.url=http:\/\/${recserver}|g'  ${api_config_file}"

eval "sed -i 's|album.recommendation.service.url=.*|album.recommendation.service.url=http:\/\/${recserver}|g'  ${api_config_file}"


# Set memcache to use containerised one
eval "sed -i 's|memcached.hosts=.*|memcached.hosts=${MEMCACHE_HOST}:${MEMCACHE_PORT}|g'  ${api_config_file}"

echo "search.host=podalirius.we7.local" >>  ${api_config_file}
echo "search.port=8980" >> ${api_config_file}

cat ${api_config_file} | grep -v "solr\." > /tmpconfig
cat /tmpconfig > ${api_config_file}

echo "fingerprinter.active=false" >> ${api_config_file}
cat /solrcfg >> ${api_config_file}


eval "sed -i 's|@SOLRHOST@|${solrhost}|g'  ${api_config_file}"


echo "======================================="
echo "Configuring tomcat keystore"
cp /artifacts/tomcat_keystore /usr/share/bbm-core-api/tomcat_keystore



#echo "======================================="
#echo "Starting haproxy"
#haproxy -f /etc/haproxy/haproxy.cfg &


echo "======================================="
echo "Starting api"
service bbm-core-api restart  


logfile="/var/lib/bbm-core-api/logs/mediagraft.log"


echo "======================================="
echo "Starting log of ${logfile}"
echo "filter by 'grep ERROR -C 25' to prevent docker log growing too large too quickly"
echo "======================================="
echo "#HELLO#" > ${logfile}
chmod 777 ${logfile}

tail -F ${logfile}  | grep ERROR -C 25

