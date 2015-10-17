#!/bin/bash
DATE=`date +%Y%m%d_%H%M%S`

mkdir -p /backups
outputfile="/backups/testdb_${DATE}"

cd /testdb-creator/
python ./testdb_backup_restore.py backupPlain ${outputfile}
python ./testdb_backup_restore.py backup ${outputfile}
