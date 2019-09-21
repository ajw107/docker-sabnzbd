#FROM lsiobase/xenial
FROM lsiobase/ubuntu:bionic
MAINTAINER sparklyballs, ajw107 (Alex Wood)

# environment settings
ARG DEBIAN_FRONTEND="noninteractive"
ENV CONFIG="/config"
ENV APP_ROOT="/app"
ENV APPDIRNAME="sabnzbd"
ENV GITURL="https://github.com/sabnzbd/sabnzbd.git"
ENV GITBRANCH="develop"
ENV APP_EXEC="SABnzbd.py"
ENV APP_OPTS="--browser 0 --config-file ${CONFIG} --server 0.0.0.0:8080"
ENV APP_COMP="/usr/bin/python3"
ENV HOME="${CONFIG}"
ENV PYTHONIOENCODING="UTF-8"
ENV LANG=C.UTF-8

#make life easy for yourself
ENV TERM=xterm-color
#Very weird, this command works with alpine image, but not xenial
#RUN echo $'#!/bin/bash\nls -alF --color=auto --group-directories-first --time-style=+"%H:%M %d/%m/%Y" --block-size="\'1" $@' > /usr/bin/ll
#RUN chmod +x /usr/bin/ll

# install packages - changed to support using git version of sabnzbd
RUN \
 apt-get update && \
 apt-get install -y \
	p7zip-full \
	unrar \
	unzip \
	nano \
	git \
    software-properties-common \
    python3-setuptools \
    python3-pip \
    libffi-dev \
    libssl-dev
#        python \ #Remove for python 3
#	python-cheetah \ #Remove for python 3
#    python-cryptography #Remove for python 3

#Review on update to Python 3 (ie is this using the python 3 versions or is requirements.txt enough)
RUN \
 add-apt-repository -y ppa:jcfp/sab-addons && \
 apt-get update && \
 apt-get install -y python-sabyenc \
                    par2-tbb

RUN \
 apt-get remove -y python2.7 && \
 apt-get autoremove -y

RUN \
   cd "${APP_ROOT}" && \
   git clone --branch ${GITBRANCH} ${GITURL} "${APPDIRNAME}" && \
   cd "${APPDIRNAME}" && \
   python3 -m pip install --upgrade pip && \
   python3 -m pip install --upgrade --requirement requirements.txt && \
   tools/make_mo.py
#   git checkout py3 && \

#RUN \ 
#pip install sabyenc --upgrade && \
#pip install cryptography --upgrade

# compile par2 multicore
#RUN \
#apt-get remove -y par2
#RUN \
#git clone https://github.com/jcfp/debpkg-par2tbb.git /tmp/par2 && \
#cd /tmp/par2 && \
#uscan --force-download && \
#dpkg-buildpackage -S -us -uc -d && \
#dpkg-source -x ../par2cmdline-tbb_*.dsc && \
#cd /tmp/par2/par2cmdline-tbb-* && \
#dpkg-buildpackage -b -us -uc && \
#dpkg -i $(readlink -f ../par2-tbb_*.deb) && \
#cd /

# cleanup
RUN \
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
