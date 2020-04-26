FROM ubuntu:18.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

ADD ./config/setup_config.sh /opt/avertem/setup_config.sh
ADD ./run_avertem.sh /opt/avertem/run_avertem.sh

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
                                 libpcre3 libpcre3-dev locales gdb gdebi \
    && locale-gen en_US.UTF-8 && \
    export AVERTEM_VERSION=$(wget -qO- https://s3-eu-west-1.amazonaws.com/avertem/linux/ubuntu/18.04/latest_version.txt) && \
    wget "https://s3-eu-west-1.amazonaws.com/avertem/linux/ubuntu/18.04/${AVERTEM_VERSION}/avertem_${AVERTEM_VERSION}_all.deb" && \
    gdebi -n avertem_${AVERTEM_VERSION}_all.deb && \
    mkdir -p /opt/avertem/scripts/ && \
    mkdir -p /opt/avertem/log

ADD ./avertem_postinst.sh /opt/avertem/scripts/

RUN /opt/avertem/scripts/avertem_postinst.sh && echo "{}" > /opt/avertem/config/genesis.json

WORKDIR /opt/avertem

CMD tail -f /dev/null


