# Extend postgresql image

* Based on postgres:9.5

Installed:
+ vim-nox
+ less
+ rman
+ pg_stat_kcache

## Setup
1. Start postgresql as usual:
```sh
docker-compose up
```

2. Run from host to setup rman:

```sh
docker exec -it pgtest bash --login -c '/root/rman_setup.sh' 
Enable required settings in postgresql.conf
PostgreSQL restart required to apply changes
```

3. We need to restart postgresql to apply new postgresl.conf:

```sh
docker-compose restart
```

4. Init rman backup directory:

```sh
docker exec -it pgtest bash --login -c '/root/rman_init.sh'
```

or

```sh
docker exec -it pgtest bash
/root/rman_init.sh
```

5. Make backup

5.1. Aliases for command

```sh
psql-connect='psql -U postgres -d postgres'
rman-full='/root/rman_full.sh'
rman-inc='/root/rman_inc.sh'
rman-ls='pg_rman show'
```

5.2. Full backup

```sh
pg_rman backup -s -b full && pg_rman validate
```

or simply `rman-full`

5.3 Incremental backup

```sh
pg_rman backup -F && pg_rman validate
```

or simply `rman-inc`


### Examples:
Stop server:
gosu postgres bash --login -c '/usr/lib/postgresql/9.5/bin/pg_ctl stop -m immediate'


---
### Usefull links:
- http://ossc-db.github.io/pg_rman/index.html
- https://coderwall.com/p/jxebnw/incremental-backups-for-postgresql
