FROM lsiobase/xenial
MAINTAINER sparklyballs

# environment settings
ENV HOME="/config"
ARG DEBIAN_FRONTEND="noninteractive"

#make life easy for yourself
ENV TERM=xterm-color
RUN echo $'#!/bin/bash\nls -alF --color=auto --group-directories-first --time-style=+"%H:%M %d/%m/%Y" --block-size="\'1" $@' > /usr/bin/ll
RUN chmod +x /usr/bin/ll

# install packages - changed to support using git version of sabnzbd
RUN \
# echo "deb http://ppa.launchpad.net/jcfp/ppa/ubuntu xenial main" | tee -a /etc/apt/sources.list && \
# apt-key adv --keyserver hkp://keyserver.ubuntu.com:11371 --recv-keys 0x98703123E0F52B2BE16D586EF13930B14BB9F05F && \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
#	sabnzbdplus \
	unrar \
	unzip 
	nano 
	git && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8080 9090
#VOLUME /config /downloads /incomplete-downloads
VOLUME /config /mnt
