FROM        mosaiksoftware/gentoo-amd64-paludis:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>


##### PACKAGE INSTALLATION #####

# install jabberd2
RUN chgrp paludisbuild /dev/tty && cave resolve -c docker-jabberd2 -x \
		-F dev-db/mysql && \
	rm -rf /usr/portage/distfiles/* /srv/binhost/*

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

################################


COPY ./config/supervisord.conf /etc/supervisord.conf

EXPOSE 5222 5223 5269

CMD exec /usr/bin/supervisord -n -c /etc/supervisord.conf
