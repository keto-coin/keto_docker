FROM ubuntu:18.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

ADD docker/build-dev/config/setup_config.sh /opt/keto/setup_config.sh
ADD docker/build-dev/run_keto.sh /opt/keto/run_keto.sh

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
    mkdir -p /opt/keto/scripts/ && \
    mkdir -p /opt/keto/log

ADD docker/build-dev/keto_postinst.sh /opt/keto/scripts/

COPY ./build/install/bin /opt/keto/bin
COPY ./build/install/data /opt/keto/data
COPY ./build/install/keys /opt/keto/keys
COPY ./build/install/lib /opt/keto/lib
COPY ./build/install/shared /opt/keto/shared
COPY ./build/install/upgrade /opt/keto/upgrade
COPY ./build/install/config /opt/keto/config


RUN /opt/keto/scripts/keto_postinst.sh && echo "{}" > /opt/keto/config/genesis.json


WORKDIR /opt/keto

CMD tail -f /dev/null


