FROM rust:1.52 as builder
RUN git clone --depth 1 --branch 0.2.0 https://github.com/kory33/home-intercom-server-rs.git /tmp/app
WORKDIR /tmp/app
RUN cargo build --release

FROM phusion/baseimage:focal-1.0.0
COPY --from=builder /tmp/app/target/release/home-intercom-server-rs /usr/local/bin/home-intercom-server-rs

RUN mkdir /etc/service/home-intercom-server-rs
COPY ./home-intercom-server-rs.sh /etc/service/home-intercom-server-rs/run
