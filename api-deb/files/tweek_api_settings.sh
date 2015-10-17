#!/bin/bash

new_api=$1
new_apis=$2
recserverport=$3
dbserverport=$4

myhost="podalirius.we7.local"
recserver="${myhost}:${recserverport}"
dbserver="${myhost}:${dbserverport}"

old_api=8080
old_apis=8443

#new_api=$port_api_http
#new_apis=$port_api_https

api_tomcat_config_file="/etc/bbm/mediagraft-tomcat.yml"
api_config_file="/etc/bbm/mediagraft.properties"

echo "API   PORTS  ${old_api},${old_apis}  ==>  ${new_api}, ${new_apis}" >> /tweek.log

if [ -e ${api_tomcat_config_file} ] ; then
  eval "sed -i 's/ort: *${old_api}/ort: ${new_api}/g' ${api_tomcat_config_file}"
  eval "sed -i 's/ort: *${old_apis}/ort: ${new_apis}/g' ${api_tomcat_config_file}"
fi

eval "sed -i 's/application.secure.url=https:\/\/localhost/application.secure.url=https:\/\/localhost:${new_apis}/g' ${api_config_file}"
eval "sed -i 's/application.url=http:\/\/localhost/application.url=http:\/\/localhost:${new_api}/g' ${api_config_file}"

eval "sed -i 's/expletives.filename=http:\/\/localhost/expletives.filename=http:\/\/localhost:${new_api}/g' ${api_config_file}"


eval "sed -i 's/=${old_api}/=${new_api}/g' ${api_config_file}"
eval "sed -i 's/=${old_apis}/=${new_apis}/g' ${api_config_file}"


# Fudge the email server settings...
eval "sed -i 's/email.host=localhost/email.host=zeus.we7.local/g' ${api_config_file}"
eval "sed -i 's/email.service.mq.name=mailer.fast/email.service.mq.name=/g' ${api_config_file}"


# prevent MOGFS uploads
eval "sed -i 's/mp3.dest.dir=dfs\:tracks\/musicSrc/mp3.dest.dir=file\:\/tmp\/mp3s_dest/g' ${api_config_file}"
eval "sed -i 's/mp3.upload.dir=dfs\:tracks\/musicUpload/mp3.upload.dir=file\:\/tmp\/mp3s_upload/g' ${api_config_file}"


#eval "sed -i 's/jdbc.hostname=localhost/jdbc.hostname=db/g' ${api_config_file}"

eval "sed -i 's/localhost\\\:5432/${dbserver}/g' ${api_config_file}"




#radio.recommendation.url=http://localhost:82
eval "sed -i 's/radio.recommendation.url=http\\\:\/\/recommendations.we7.com/radio.recommendation.url=http:\/\/${recserver}/g' ${api_config_file}"

eval "sed -i 's/track.recommendation.service.url=http\\\:\/\/recommendations.we7.com/track.recommendation.service.url=http:\/\/${recserver}/g'  ${api_config_file}"

eval "sed -i 's/artist.recommendation.service.url=http\\\:\/\/recommendations.we7.com/artist.recommendation.service.url=http:\/\/${recserver}/g'  ${api_config_file}"

eval "sed -i 's/album.recommendation.service.url=http\\\:\/\/recommendations.we7.com/album.recommendation.service.url=http:\/\/${recserver}/g'  ${api_config_file}"


# Set memcache to use containerised one
eval "sed -i 's/memcached.hosts=localhost\\\:11211/memcached.hosts=${myhost}:11212/g'  ${api_config_file}"





echo "DONE" >> /tweek.log

