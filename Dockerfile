FROM lsiobase/xenial
MAINTAINER sparklyballs, ajw107 (Alex Wood)

# environment settings
ENV CONFIG="/config"
ENV APP_ROOT="/app"
ENV APPDIRNAME="sabnzbd"
ENV GITURL="https://github.com/sabnzbd/sabnzbd.git"
ENV GITBRANCH="develop"
ENV APP_EXEC="SABnzbd.py"
ENV APP_OPTS="--config-file /config --server 0.0.0.0:8080"
ENV APP_COMP="/usr/bin/python2.7"
ENV HOME="${CONFIG}"
ARG DEBIAN_FRONTEND="noninteractive"

#make life easy for yourself
ENV TERM=xterm-color
#Very weird, this command works with alpine image, but not xenial
#RUN echo $'#!/bin/bash\nls -alF --color=auto --group-directories-first --time-style=+"%H:%M %d/%m/%Y" --block-size="\'1" $@' > /usr/bin/ll
#RUN chmod +x /usr/bin/ll

# install packages - changed to support using git version of sabnzbd
RUN \
# echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list && \
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
#	sabnzbdplus \
	unrar \
	unzip \
	nano \
	git && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /
RUN chmod +x /usr/bin/ll

# ports and volumes
EXPOSE 8080 9090
#VOLUME /config /downloads /incomplete-downloads
VOLUME "${CONFIG}" /mnt
