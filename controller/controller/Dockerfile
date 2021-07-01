FROM phusion/baseimage:focal-1.0.0

CMD ["/sbin/my_init"]

# install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | gpg \
      --batch --yes \
      --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb \
      [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
      https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && \
    apt-get install -y \
      docker-ce docker-ce-cli containerd.io

# install docker-compose
RUN apt-get install -y python3-pip
RUN yes | pip install docker-compose

RUN apt-get install -y git

# clean apt
RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir -p /root/controller-trigger \
    mkdir -p /root/servers-repo
COPY entrypoint.sh /etc/service/service_controller/run
