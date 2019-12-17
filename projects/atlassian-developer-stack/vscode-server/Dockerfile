FROM ubuntu:18.04

ARG USER=docker
ARG UID=1000
ARG GID=1000

ARG CODE_RELEASE="2.1692-vsc1.39.2"

# Update & Upgrade system
RUN apt-get -y update && apt-get -y upgrade

# Install dependencies
RUN apt-get -y install ssh sudo git curl

# Make sure we have bash as our default shell
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install code-server
RUN \
 if [ -z ${CODE_RELEASE+x} ]; then \
	CODE_RELEASE=$(curl -sX GET "https://api.github.com/repos/cdr/code-server/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 echo "**** installing code-server ${CODE_RELEASE}****" && \
 curl -o \
 /tmp/code.tar.gz -L \
    	"https://github.com/cdr/code-server/releases/download/${CODE_RELEASE}/code-server${CODE_RELEASE}-linux-x86_64.tar.gz" && \
 tar xzf /tmp/code.tar.gz -C \
	/usr/bin/ --strip-components=1 \
  --wildcards code-server*/code-server && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh

# Create user
RUN useradd -m ${USER} --uid=${UID}
RUN passwd -d ${USER}
RUN adduser ${USER} sudo

# Setup default user, when enter docker container
USER ${UID}:${GID}
RUN mkdir -p /home/${USER}/.local/share/code-server
RUN mkdir /home/${USER}/workspace
RUN chown ${UID}:${GID} /home/${USER}/workspace
WORKDIR /home/${USER}

EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
