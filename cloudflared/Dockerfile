FROM crazymax/cloudflared:2021.5.7

USER root

# install yq (see https://mikefarah.gitbook.io/yq/#install)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_arm64.tar.gz -O -\
    | tar xz && mv yq_linux_arm64 /usr/bin/yq

RUN mkdir -p /tmp

COPY ./entrypoint.sh /tmp/entrypoint.sh
COPY ./tunnel-config.yaml /tmp/tunnel-config.yaml

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
