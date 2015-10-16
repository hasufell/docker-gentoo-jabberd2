## Installation

```sh
docker build -t hasufell/gentoo-jabberd2 .
```

Also get the mysql image:

```sh
docker pull hasufell/gentoo-mysql
```

## Configuration

Configuration should be mounted in from the host or a data volume container
at `/etc/jabber/`.

## Running

### Database

Start the mysql container:

```sh
docker run -ti -d \
	--name=jabberd2-mysql \
	-v /srv/mysql-jabberd2:/var/lib/mysql \
	-p 3309 \
	-e MYSQL_PORT=3309 \
	-e MYSQL_PASS=<admin-pq> \
	hasufell/gentoo-mysql
```

Copy the mysqldump or raw db scheme
(`/usr/share/doc/jabberd2-*/tools/db-setup.mysql`) to e.g
`/srv/mysql-jabberd2/`, then inject the dump/scheme:

```sh
docker exec -ti \
	jabberd2-mysql \
	/bin/bash -c "mysqladmin -u root create jabberd2 && mysql -u root jabberd2 < /var/lib/mysql/<dump.sql> && echo \"GRANT select,insert,delete,update ON jabberd2.* to 'jabberd2'@'%' IDENTIFIED by '<jabberd2-mysql-pw>';\" | mysql -u root"
```

### Jabberd2

A full command could look like this:

```sh
docker run -ti -d \
	--name=jabberd2 \
	--link jabberd2-mysql:jabberd2-mysql \
	-v <config-folder>:/etc/jabber \
	-p 5222:5222 \
	-p 5223:5223 \
	-p 5269:5269 \
	hasufell/gentoo-jabberd2
```


