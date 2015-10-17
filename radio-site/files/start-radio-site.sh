#!/bin/bash


if [ -e /radiosite ] ; then
  rm -rf /radio-site
  mv /radiosite /radio-site
fi

APIHOST=$1
APIPORT=$2
APISECPORT=$3

RSHOST=$4
RSPORT=$5
RSSECPORT=$6

RECHOST=$7
RECPORT=$8

MEMCACHE=$9

if [ "${APISP}" == "" ] ; then
  APISP="http"
fi

if [ "${RSDEBUG}" == "1" ] ; then
  DEBUG="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=8000"
else
  DEBUG=""
fi


config_file="/etc/we7/local.props"
tomcat_config_file="/etc/bbm/radio-site-tomcat.yml"

if [ -e ${tomcat_config_file} ] ; then
  eval "sed -i 's/@http@/${RSPORT}/g' ${tomcat_config_file}"
  eval "sed -i 's/@https@/${RSSECPORT}/g' ${tomcat_config_file}"
  
  eval "sed -i 's/@shutdown@/8105/g' ${tomcat_config_file}"
fi

eval "sed -i 's/@APISP@/${APISP}/g' ${config_file}"


eval "sed -i 's/@APIHOST@/${APIHOST}/g' ${config_file}"
eval "sed -i 's/@APIPORT@/${APIPORT}/g' ${config_file}"
eval "sed -i 's/@APISECPORT@/${APISECPORT}/g' ${config_file}"

eval "sed -i 's/@RSHOST@/${RSHOST}/g' ${config_file}"
eval "sed -i 's/@RSPORT@/${RSPORT}/g' ${config_file}"
eval "sed -i 's/@RSSECPORT@/${RSSECPORT}/g' ${config_file}"

eval "sed -i 's/@RECHOST@/${RECHOST}/g' ${config_file}"
eval "sed -i 's/@RECPORT@/${RECPORT}/g' ${config_file}"

eval "sed -i 's/@MEMCACHE@/${MEMCACHE}/g' ${config_file}"


#cp -f /usr/share/bbm-radio-site/tomcat_keystore /radio-site/tomcat_keystore

LOGDIR="/radio-site/build/logs"
LOGDIR="/var/logs/radiosite"

LOGCFG="-Dlog4j.configuration=file:/etc/bbm/radio-site-log4j.xml -Dlogging.dir=${LOGDIR}"

mkdir -p ${LOGDIR}

/usr/lib/jvm/jdk-8-oracle-x64/bin/java ${DEBUG} ${LOGCFG}  -jar /radio-site/build/libs/radio-site.war ${tomcat_config_file} /radio-site/build/libs/radio-site.war 2> ${LOGDIR}/stdout.log  &

tail -F  ${LOGDIR}/radiosite.log
