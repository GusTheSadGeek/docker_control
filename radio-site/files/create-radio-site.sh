#!/bin/bash

APIHOST=$1
APIPORT=$2
APISECPORT=$3

RSHOST=$4
RSPORT=$5
RSSECPORT=$6

RECHOST=$7
RECPORT=$8

MEMCACHE=$9

config_file="/etc/we7/local.props"
tomcat_config_file="/etc/bbm/radio-site-tomcat.yml"

mv /etc/we7/local.props /etc/we7/TEMP_local.props

cp -r /tempradiosite /radio-site

cd /radio-site
# gradlew 2.3
#./gradlew --console=plain start

# gradlew 2.2
./gradlew --no-color start
rc=$?
if [[ ${rc} == 0 ]] ; then
  ./gradlew shutdown 
  mkdir /radiosite &&  cp -r /radio-site/build /radiosite/build &&  cp -r /radio-site/etc /radiosite/etc &&  mv /etc/we7/TEMP_local.props /etc/we7/local.props
else
  ./gradlew shutdown
fi

# Tidy up artifacts
cd /
rm -rf radio-site
#cd /root
#ls -al
#cd /
#ls -al
