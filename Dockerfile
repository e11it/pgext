FROM postgres:9.5

RUN localedef -i ru_RU -c -f UTF-8 -A /usr/share/locale/locale.alias ru_RU.UTF-8
ENV LANG ru_RU.utf8

ENV RMAN_VER 1.3.2


RUN groupadd -g 998 rman &&\
    useradd -g rman -G postgres -u 998 rman -s /bin/bash -d /share/pg_rman && \
    mkdir -p /share/pg_wall &&\
    chgrp -R postgres /share/pg_wall &&\
    chmod g+w /share/pg_wall

COPY pg_rman /share/pg_rman

RUN chown -R rman:rman /share/pg_rman &&\
	chmod +x /share/pg_rman/*.sh

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y \
	gcc \
    jq \
    make \
    git  \
    postgresql-contrib-$PG_MAJOR \
    postgresql-server-dev-$PG_MAJOR \
    wget \
    libpam-dev \
    libedit-dev \
    zlib1g-dev \
    libselinux1-dev \
    vim-nox \
	&& wget -O- $(wget -O- https://api.github.com/repos/dalibo/pg_stat_kcache/releases/latest|jq -r '.tarball_url') | tar -xzf - \
	&& for f in $(ls); do cd $f; make install; cd ..; rm -rf $f; done \
	&& cd /var/tmp \
	&& wget -O- https://github.com/ossc-db/pg_rman/releases/download/v${RMAN_VER}/pg_rman-${RMAN_VER}-pg95.tar.gz | tar -xzf - \
	&& for f in $(ls); do cd $f; make; make install; cd ..; rm -rf $f; done \
	&& ln -s /usr/lib/postgresql/$PG_MAJOR/bin/pg_rman /bin/pg_rman \
	&& apt-get purge -y --auto-remove git gcc jq make postgresql-server-dev-$PG_MAJOR wget \
    && rm -rf /var/lib/apt/lists/*

VOLUME /share/pg_rman
VOLUME /share/pg_wall

COPY docker-entrypoint-fix.sh /
ENTRYPOINT ["/docker-entrypoint-fix.sh"]
EXPOSE 5432
CMD ["postgres"]
# http://www.postgresql.org/docs/current/static/server-shutdown.html
STOPSIGNAL SIGINT

# vim:set ft=dockerfile:
