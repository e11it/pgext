#!/bin/bash

if [ ! -d "/share/pg_rman/backup" ]; then
	echo "No backup folder '/share/pg_rman/backup'"
	echo "Inf: init required. Please run /root/rman_init.sh"
	exit 1
fi

pg_rman backup -F && pg_rman validate
