FROM debian:jessie
MAINTAINER birru vikas chennybirru@gmail.com
RUN echo "deb http://http.debian.net/debian jessie-backports main" >> /etc/apt/sources.list
RUN apt-get -qqy update
RUN apt-get install -qqy apt-utils sudo
#RUN apt install -qqy -t jessie-backports openjdk-8-jre-headless ca-certificates-java
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections && \
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
RUN apt-get install software-properties-common -y && add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" && apt-get update
RUN apt-get install oracle-java8-installer -y
RUN apt-get install -qyy procps
RUN apt-get install -qqy socat
RUN apt-get install -qqy sudo
RUN apt-get install -qqy wget
RUN apt-get install -qqy curl
RUN apt-get install -qqy cron
RUN apt-get install -qqy ntp
RUN apt-get install -qqy python
RUN apt-get install -qqy jq
#RUN apt-get install -qqy openjdk-8-jre-headless
RUN apt-get install -qqy sysvinit-core
RUN apt-get install -qqy sysvinit-utils
RUN apt-get install -qqy build-essential
RUN apt-get remove --purge --auto-remove systemd -y
RUN curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN echo "deb http://pub-repo.sematext.com/debian sematext main" >> /etc/apt/sources.list && \
	wget -O - https://pub-repo.sematext.com/debian/sematext.gpg.key |  apt-key add - && \
    apt-get update -qqy && \
    apt-get install --force-yes -qqy spm-client nodejs && \
    apt-get autoremove && apt-get autoclean && \
    npm i spm-agent-mongodb sematext-agent-httpd sematext-agent-nginx -g
ADD ./run.sh /run.sh
ADD ./docker-info.js /tmp/di/docker-info.js
ADD ./package.json  /tmp/di/package.json
ADD ./netmap.sh /opt/spm/bin/netmap.sh
RUN chmod +x run.sh && chmod +x /opt/spm/bin/netmap.sh 
RUN chmod +x /opt/spm/bin/spm-client-setup-conf.sh 
RUN chmod +x /tmp/di/docker-info.js 
RUN ln /usr/bin/env /bin/env 
RUN npm i /tmp/di/ -g
ENV PATH ${PATH}:/opt/spm/bin/
VOLUME /opt/spm
CMD ["/run.sh"]
