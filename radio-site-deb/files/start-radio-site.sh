#!/bin/bash

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
if [ "$WEB_HOST" == "" ] ; then
  echo "WEB_HOST not defined"
  exit 4
fi
if [ "$WEB_PORT" == "" ] ; then
  echo "WEB_PORT not defined"
  exit 5
fi
if [ "$WEB_SEC_PORT" == "" ] ; then
  echo "WEB_SEC_PORT not defined"
  exit 6
fi


if [ "$REC_PORT" == "" ] ; then
  echo "REC_PORT not defined"
  exit 7
fi
if [ "$REC_HOST" == "" ] ; then
  echo "REC_HOST not defined"
  exit 8
fi
if [ "$MEMCACHE_PORT" == "" ] ; then
  echo "MEMCACHE_PORT not defined"
  exit 9
fi
if [ "$MEMCACHE_HOST" == "" ] ; then
  echo "MEMCACHE_HOST not defined"
  exit 10
fi

echo "10.0.2.15 dockerVM" >> /etc/hosts
if [ "$PC_NAME" != "" ] ; then
  echo "10.0.2.15 $PC_NAME" >> /etc/hosts
fi

recserver="${REC_HOST}:${REC_PORT}"
memcacheserver="${MEMCACHE_HOST}:${MEMCACHE_PORT}"

if [ "${APISP}" == "" ] ; then
  APISP="https"
fi

if [ "${DEBUG_PORT}" != "" ] ; then
  DEBUG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=${DEBUG_PORT}"
else
  DEBUG=""
fi

echo "======================================="
echo "Configuring tomcat keystore"
cp /artifacts/tomcat_keystore /usr/share/bbm-radio-site/tomcat_keystore

config_file="/etc/we7/local.props"
tomcat_config_file="/etc/bbm/radio-site-tomcat.yml"

echo "======================================="
echo "Configuring ${tomcat_config_file}"

if [ -e ${tomcat_config_file} ] ; then
  eval "sed -i 's/@http@/${WEB_PORT}/g' ${tomcat_config_file}"
  eval "sed -i 's/@https@/${WEB_SEC_PORT}/g' ${tomcat_config_file}"
  eval "sed -i 's/@shutdown@/8105/g' ${tomcat_config_file}"
fi

echo "======================================="
echo "Configuring ${config_file}"

eval "sed -i 's/@APISP@/${APISP}/g' ${config_file}"

eval "sed -i 's/@APIHOST@/${API_HOST}/g' ${config_file}"
eval "sed -i 's/@APIPORT@/${API_PORT}/g' ${config_file}"
eval "sed -i 's/@APISECPORT@/${API_SEC_PORT}/g' ${config_file}"

eval "sed -i 's/@RSHOST@/${WEB_HOST}/g' ${config_file}"
eval "sed -i 's/@RSPORT@/${WEB_PORT}/g' ${config_file}"
eval "sed -i 's/@RSSECPORT@/${WEB_SEC_PORT}/g' ${config_file}"

eval "sed -i 's/@RECHOST@/${REC_HOST}/g' ${config_file}"
eval "sed -i 's/@RECPORT@/${REC_PORT}/g' ${config_file}"

eval "sed -i 's/@MEMCACHE@/${memcacheserver}/g' ${config_file}"


logfile="/tmp/tomcat/logs/radiosite/mediagraft.log"

echo "======================================="
echo "Starting radio-site"
java $DEBUG -Xmx2048M -XX:+UseConcMarkSweepGC -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M -Djava.io.tmpdir=/var/tmp/bbm-radio-site -Dlog4j.configuration=file:/etc/bbm/radio-site-log4j.xml -jar /usr/share/bbm-radio-site/radio-site.war /etc/bbm/radio-site-tomcat.yml /usr/share/bbm-radio-site/radio-site.war &

echo "======================================="
echo "Starting log of ${logfile}"
echo "filter by 'grep ERROR -C 25' to prevent docker log growing too large too quickly"
echo "======================================="
sleep 10 # wait for log to start
head -n 50 ${logfile}
tail -F ${logfile} | grep ERROR -C 25

