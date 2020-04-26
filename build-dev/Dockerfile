FROM ubuntu:18.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

ADD docker/build-dev/config/setup_config.sh /opt/avertem/setup_config.sh
ADD docker/build-dev/run_avertem.sh /opt/avertem/run_avertem.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -y install wget \
    && apt-get update \
    && apt-get -y install clang-6.0 lldb-4.0 libclang-6.0-dev cmake make \
                                 libbz2-dev libssl-dev libgmp3-dev \
                                 autotools-dev build-essential \
                                 libbz2-dev libicu-dev python-dev \
                                 autoconf libtool git curl \
                                 libgflags-dev libsnappy-dev \
                                 zlib1g-dev liblz4-dev libzstd-dev \
                                 bison libbison-dev flex libfl-dev \
                                 gtk-doc-tools libxml2-dev libdb-dev \
                                 libpcre3 libpcre3-dev locales gdb \
    && locale-gen en_US.UTF-8 && \
    mkdir -p /opt/avertem/scripts/ && \
    mkdir -p /opt/avertem/log

ADD docker/build-dev/avertem_postinst.sh /opt/avertem/scripts/

COPY ./build/install/bin /opt/avertem/bin
COPY ./build/install/data /opt/avertem/data
COPY ./build/install/keys /opt/avertem/keys
COPY ./build/install/lib /opt/avertem/lib
COPY ./build/install/shared /opt/avertem/shared
COPY ./build/install/upgrade /opt/avertem/upgrade
COPY ./build/install/config /opt/avertem/config


RUN /opt/avertem/scripts/avertem_postinst.sh && echo "{}" > /opt/avertem/config/genesis.json


WORKDIR /opt/avertem

CMD tail -f /dev/null


