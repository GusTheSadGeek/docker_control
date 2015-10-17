#!/bin/bash


cd /etc/puppet
ln -s /files/puppet/hiera.yaml hiera.yaml
rm /files/puppet/hieradata/common.yaml
cd /files
FACTER_we7_environment='docker'  /usr/bin/puppet apply manifests/solr_docker.pp --modulepath=puppet/modules  we7-environment=docker --tags sdfasdasd

FACTER_we7_environment='docker'  /usr/bin/puppet apply manifests/solr_docker.pp --modulepath=puppet/modules  we7-environment=docker --tags repository
/usr/bin/apt-get update
FACTER_we7_environment='docker'  /usr/bin/puppet apply manifests/solr_docker.pp --modulepath=puppet/modules  we7-environment=docker


#apt-get remove -yqq oracle-java8-jdk oracle-java7-jdk
apt-get autoremove -yqq

