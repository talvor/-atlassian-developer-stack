FROM node:10.16.3

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# The node image comes with a base non-root 'node' user which this Dockerfile
# gives sudo access. However, for Linux, this user's GID/UID must match your local
# user UID/GID to avoid permission issues with bind mounts. Update USER_UID / USER_GID 
# if yours is not 1000. See https://aka.ms/vscode-remote/containers/non-root-user.
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG CODE_RELEASE="2.1692-vsc1.39.2"

RUN echo "(ARGS) username=$USERNAME uid=$USER_UID"

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \ 
    #
    # Verify git and needed tools are installed
    && apt-get install -y git procps \
    #
    # Remove outdated yarn from /opt and install via package 
    # so it can be easily updated via apt-get upgrade yarn
    && rm -rf /opt/yarn-* \
    && rm -f /usr/local/bin/yarn \
    && rm -f /usr/local/bin/yarnpkg \
    && apt-get install -y curl apt-transport-https lsb-release \
    && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
    && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install --no-install-recommends yarn \
    #
    # Install eslint globally
    && npm install -g eslint \
    #
    # Install nodemon globally
    && npm install -g nodemon \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && if [ "$USER_GID" != "1000" ]; then groupadd --gid $USER_GID $USERNAME; fi \
    && if [ "$USER_GID" != "1000" ]; then useradd --uid $USER_UID --gid $USER_GID -m $USERNAME; fi \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Fix locale
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8

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

# Install ngrok
RUN \
	echo "**** installing ngrok****" && \
	curl -o \
	/tmp/ngrok.zip -L \
			"https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip" && \
	unzip /tmp/ngrok.zip -d /usr/bin/ && \
	echo "**** clean up ****" && \
	rm -rf \
		/tmp/*
        
# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

ENV SHELL /bin/bash

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh

# Setup default user, when enter docker container
USER ${USERNAME}
RUN mkdir -p /home/${USERNAME}/workspace
RUN chown ${USER_UID}:${USER_GID} /home/${USERNAME}/workspace
RUN mkdir -p /home/${USERNAME}/.local/share/code-server
RUN chown ${USER_UID}:${USER_GID} /home/${USERNAME}/.local/share/code-server
WORKDIR /home/${USERNAME}

EXPOSE 3000 8080
ENTRYPOINT ["docker-entrypoint.sh"]
