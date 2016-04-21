#!/bin/bash

gosu postgres bash --login -c 'pg_rman init'

if [ $? == 0 ]; then 
	echo "BACKUP_MODE = INCREMENTAL" >> /share/pg_rman/backup/pg_rman.ini 
	echo "COMPRESS_DATA = YES" >> /share/pg_rman/backup/pg_rman.ini 
	echo "KEEP_ARCLOG_DAYS = 7" >> /share/pg_rman/backup/pg_rman.ini 
	echo "KEEP_DATA_GENERATIONS = 2" >> /share/pg_rman/backup/pg_rman.ini
	echo "KEEP_SRVLOG_FILES = 10" >> /share/pg_rman/backup/pg_rman.ini 
else
	echo "Init failed"
	exit 1
fi

echo "Result pg_rman.ini:"
cat /share/pg_rman/backup/pg_rman.ini
