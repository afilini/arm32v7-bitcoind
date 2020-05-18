FROM fedora:latest

ARG USER_ID
ARG GROUP_ID

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

RUN groupadd -g ${GROUP_ID} electrs \
	&& useradd -u ${USER_ID} -g electrs --system --shell /bin/false electrs

ADD ./bin /usr/bin

VOLUME ["/electrs", "/bitcoin"]

# Electrum RPC and Prometheus monitoring
EXPOSE 50001 4224

WORKDIR /electrs

USER ${USER_ID}:${GROUP_ID}

CMD ["electrs_oneshot"]

STOPSIGNAL SIGINT
