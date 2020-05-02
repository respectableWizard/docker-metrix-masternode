FROM ubuntu:xenial
MAINTAINER respectawiz <respectablewizard@gmail.com>

ARG USER_ID
ARG GROUP_ID
ARG VERSION

ENV USER metrix
ENV COMPONENT Metrix-linux-x64.tar.gz
ENV HOME /home/${USER}
ENV PORT 33820

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} ${USER} \
	&& useradd -u ${USER_ID} -g ${USER} -s /bin/bash -m -d ${HOME} ${USER}

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
    && apt-get update  \
    && apt-get install -y --no-install-recommends ca-certificates wget software-properties-common \
    && apt-add-repository ppa:bitcoin/bitcoin \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && gosu nobody true

ENV VERSION ${VERSION:-3.4.7}
RUN wget -O /tmp/${COMPONENT} "https://github.com/TheLindaProjectInc/Metrix/releases/download/${VERSION}/${COMPONENT}" \
    && tar -xzvf /tmp/${COMPONENT} -C /usr/local/bin/

EXPOSE ${PORT}

VOLUME ["${HOME}"]
WORKDIR ${HOME}
ADD ./bin /usr/local/bin
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start-unprivileged.sh"]
