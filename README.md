# Extended official postgresql image

* Based on postgres:9.5

## Installed:
+ vim-nox
+ less
+ rman
+ pg_stat_kcache

## Setup
### 1. Start postgresql as usual:

```sh
host:~# docker-compose up
```

### 2. Run from host to setup rman:

```sh
host:~# docker exec -it pgtest bash --login -c '/root/rman_setup.sh' 
Enable required settings in postgresql.conf
PostgreSQL restart required to apply changes
```

### 3. We need to restart postgresql to apply new postgresl.conf:

```sh
host:~# docker-compose restart
```

### 4. Init rman backup directory:

```sh
host:~# docker exec -it pgtest bash --login -c '/root/rman_init.sh'
```

or

```sh
host:~# docker exec -it pgtest bash
container:~# /root/rman_init.sh
```

### 5. Make backup

#### 5.1. Aliases for command

```sh
psql-connect='psql -U postgres -d postgres'
rman-full='/root/rman_full.sh'
rman-inc='/root/rman_inc.sh'
rman-ls='pg_rman show'
```

#### 5.2. Full backup

* Inside container

```sh
container:~# pg_rman backup -s -b full && pg_rman validate
```

or simply 

```sh
container:~# rman-full
```

* From host

> Can be used to automate with cron

```sh
host:~# docker exec -it pgtest bash -l -c '/root/rman_full.sh'
INFO: copying database files
ЗАМЕЧАНИЕ:  команда pg_stop_backup завершена, все требуемые сегменты WAL заархивированы
INFO: copying archived WAL files
INFO: copying server log files
INFO: backup complete
HINT: Please execute 'pg_rman validate' to verify the files are correctly copied.
INFO: start deleting old archived WAL files from ARCLOG_PATH (keep days = 7)
INFO: the threshold timestamp calculated by keep days is "2016-04-14 00:00:00"
INFO: start deleting old server files from SRVLOG_PATH (keep files = 10)
INFO: start deleting old backup (keep generations = 2)
INFO: does not include the backup just taken
INFO: backup "2016-04-21 21:01:17" should be kept
DETAIL: This belongs to the 1st latest full backup.
INFO: backup "2016-04-21 20:59:12" should be kept
DETAIL: This is the 1st latest full backup.
INFO: backup "2016-04-21 15:04:57" should be kept
DETAIL: This belongs to the 2nd latest full backup.
INFO: backup "2016-04-21 15:03:36" should be kept
DETAIL: This is the 2nd latest full backup.
INFO: validate: "2016-04-21 21:05:51" backup, archive log files and server log files by CRC
INFO: backup "2016-04-21 21:05:51" is valid
```
### 5.3. Incremental backup

* Inside container

```sh
container:~# pg_rman backup -F && pg_rman validate
```

or simply 

```sh
rman-inc
```

* From host

> Can be used to automate with cron

```sh
host:~# docker exec -it pgtest bash -l -c '/root/rman_inc.sh'
INFO: copying database files
ЗАМЕЧАНИЕ:  команда pg_stop_backup завершена, все требуемые сегменты WAL заархивированы
INFO: copying archived WAL files
INFO: backup complete
HINT: Please execute 'pg_rman validate' to verify the files are correctly copied.
INFO: start deleting old archived WAL files from ARCLOG_PATH (keep days = 7)
INFO: the threshold timestamp calculated by keep days is "2016-04-14 00:00:00"
INFO: start deleting old backup (keep generations = 2)
INFO: does not include the backup just taken
INFO: backup "2016-04-21 20:59:12" should be kept
DETAIL: This is the 1st latest full backup.
INFO: backup "2016-04-21 15:04:57" should be kept
DETAIL: This belongs to the 2nd latest full backup.
INFO: backup "2016-04-21 15:03:36" should be kept
DETAIL: This is the 2nd latest full backup.
INFO: validate: "2016-04-21 21:01:17" backup and archive log files by CRC
INFO: backup "2016-04-21 21:01:17" is valid
```

### 5.4. List backup

* Short

```sh
container:~# pg_rman show
==========================================================
 StartTime           Mode  Duration    Size   TLI  Status 
==========================================================
2016-04-21 15:04:57  INCR        0m   904kB     1  OK
2016-04-21 15:03:36  FULL        0m  4427kB     1  OK
```

* Detail

```sh
container:~# pg_rman show detail
============================================================================================================
 StartTime           Mode  Duration    Data  ArcLog  SrvLog   Total  Compressed  CurTLI  ParentTLI  Status  
============================================================================================================
2016-04-21 15:04:57  INCR        0m  7225kB    33MB    ----   904kB        true       1          0  OK
2016-04-21 15:03:36  FULL        0m    21MB    83MB      0B  4427kB        true       1          0  OK
```

* Detail for item

```sh
container:~# pg_rman show detail '2016-04-21 15:04:57'
# configuration
BACKUP_MODE=INCREMENTAL
FULL_BACKUP_ON_ERROR=true
WITH_SERVERLOG=false
COMPRESS_DATA=true
# result
TIMELINEID=1
START_LSN=0/07000028
STOP_LSN=0/070000f8
START_TIME='2016-04-21 15:04:57'
END_TIME='2016-04-21 15:04:59'
RECOVERY_XID=634
RECOVERY_TIME='2016-04-21 15:04:59'
TOTAL_DATA_BYTES=28881704
READ_DATA_BYTES=7225032
READ_ARCLOG_BYTES=33554748
WRITE_BYTES=904942
BLOCK_SIZE=8192
XLOG_BLOCK_SIZE=8192
STATUS=OK
```

---
### Usefull links:
- http://ossc-db.github.io/pg_rman/index.html
- https://coderwall.com/p/jxebnw/incremental-backups-for-postgresql
