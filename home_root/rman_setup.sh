#!/bin/bash

# Functions
#

# pg_enable() setup requied for pg_rman options in postgresql.conf.
# Arg: path to pstgresql.conf
pg_enable()
{
	FILE=$1
	if [ -f $FILE ]; then
		sed -ri 's/^\s*?#?\s*?(archive_mode)\s?=(.[^#]+)(\#.+?)?$/\1 = on \3/' $FILE
		# -> archive_command = 'test ! -f /share/pg_wall/%f && cp %p /share/pg_wall/%f'
		sed -ri 's/^\s*?#?\s*?(archive_command)\s?=(.[^#]+)(\#.+?)?$/\1 = \x27test ! -f \/share\/pg_wall\/%f \&\& cp %p \/share\/pg_wall\/%f\x27 \3/' $FILE
		# wal_level = hot_standby
		sed -ri 's/^\s*?#?\s*?(wal_level)\s?=(.[^#]+)(\#.+?)?$/\1 = hot_standby \3/' $FILE
	else
		echo "Function pg_enable(). Argument '$FILE' is not exist file"
		exit 1
	fi
}


if [[ $(id -u) -ne 0 ]] ; then
	echo "Please run as root"
	exit 1
fi


if [ -f "/var/lib/postgresql/data/postgresql.conf" ]; then
	echo "Enable required settings in postgresql.conf"
	pg_enable /var/lib/postgresql/data/postgresql.conf

	echo "PostgreSQL restart required to apply changes"
fi
