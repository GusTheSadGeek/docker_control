#!/bin/bash


HOSTNAME=$1
API_PORT_UNSEC=$2
API_PORT_SEC=$3
SSL=$4
VM=$5

echo "10.0.2.15 dockerVM" >> /etc/hosts
if [ "$VM" == "VM" ] ; then
  echo "10.0.2.15 $HOSTNAME" >> /etc/hosts
fi

echo " "  > /testdb-creator/local-testdb.cfg
echo "[mediagraft]" >> /testdb-creator/local-testdb.cfg
echo "ssl=${SSL}" >> /testdb-creator/local-testdb.cfg
echo "mediagraft_path=/"  >> /testdb-creator/local-testdb.cfg
echo "hostname=${HOSTNAME}"  >> /testdb-creator/local-testdb.cfg
echo "port=${API_PORT_UNSEC}"  >> /testdb-creator/local-testdb.cfg
echo "secure_port=${API_PORT_SEC}"  >> /testdb-creator/local-testdb.cfg
echo "path="  >> /testdb-creator/local-testdb.cfg
echo " "  >> /testdb-creator/local-testdb.cfg

#cat /testdb-creator/local-testdb.cfg
#cat /etc/hosts

cd /testdb-creator

export PYTHONPATH=/vagrant/testdb-creator/venv:/usr/local/lib/python2.7/dist-packages:/usr/lib/python2.7/dist-packages
. venv/bin/activate
python ./stage14_solrIndexing.py
