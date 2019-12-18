FROM ubuntu:18.04

ARG USERNAME=docker
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG CODE_RELEASE="2.1692-vsc1.39.2"

RUN echo "(ARGS) username=$USERNAME uid=$USER_UID"

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \ 
    #
    # Verify git and needed tools are installed
    && apt-get install -y git procps curl \
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

EXPOSE 8080
ENTRYPOINT ["docker-entrypoint.sh"]
