FROM fedora:latest
MAINTAINER Alekos Filini - @afilini

ARG USER_ID
ARG GROUP_ID

ARG BITCOIN_VERSION
ENV BITCOIN_VERSION ${BITCOIN_VERSION:-0.19.1}

ENV HOME /bitcoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} bitcoin \
	&& useradd -u ${USER_ID} -g bitcoin -s /bin/bash -m -d /bitcoin bitcoin \
        && gpg --no-default-keyring --keyring ~/.gnupg/pubring.gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 01EA5486DE18A882D4C2684590C8019E36C2E964 \
        && curl -O -L https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz \
        && curl -O -L https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
        && sha256sum --ignore-missing --check SHA256SUMS.asc \
        && gpg --no-default-keyring --keyring ~/.gnupg/pubring.gpg --verify SHA256SUMS.asc \
        && tar xvf bitcoin-${BITCOIN_VERSION}-arm-linux-gnueabihf.tar.gz \
        && rm -rf *.tar.gz *.asc bitcoin-${BITCOIN_VERSION}/README.md \
        && cp -Rv bitcoin-${BITCOIN_VERSION}/* /usr/local/ 

ADD ./bin /usr/local/bin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoin

USER ${USER_ID}:${GROUP_ID}

CMD ["btc_oneshot"]
