FROM alpine as cloudflared-builder

USER root

# install dependencies
RUN apk --update --no-cache add \
    bash \
    build-base \
    go \
    gcc \
    git \
  && rm -rf /tmp/* /var/cache/apk/*

RUN git clone \
    --depth 1 \
    --branch 2021.5.10 \
    https://github.com/cloudflare/cloudflared /go/src/github.com/cloudflare/cloudflared

WORKDIR /go/src/github.com/cloudflare/cloudflared

ENV GO111MODULE=on
ENV CGO_ENABLED=0
RUN go build -v -mod vendor \
    -ldflags \
    "-w -s -X 'main.Version=2021.5.10' -X 'main.BuildTime=$(date -u +'%Y-%m-%dT%H:%M:%SZ')'" \
    github.com/cloudflare/cloudflared/cmd/cloudflared

FROM alpine
COPY --from=cloudflared-builder /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/cloudflared

# install yq (see https://mikefarah.gitbook.io/yq/#install)
RUN wget https://github.com/mikefarah/yq/releases/download/v4.9.6/yq_linux_arm64.tar.gz -O -\
    | tar xz && mv yq_linux_arm64 /usr/bin/yq

RUN mkdir -p /tmp

COPY ./entrypoint.sh /tmp/entrypoint.sh
COPY ./tunnel-config.yaml /tmp/tunnel-config.yaml
COPY ./reroute.sh /tmp/reroute.sh

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
