#!/bin/bash

if grep --quiet "rman" getfacl /var/lib/postgresql/data; then
	setfacl -R -m u:rman:rwx /var/lib/postgresql/data/
	setfacl -dR -m u:rman:rwx /var/lib/postgresql/data/
fi

if grep --quiet "rman" getfacl /share/pg_wall; then
	setfacl -dR -m u:rman:rwx /share/pg_wall/
fi
