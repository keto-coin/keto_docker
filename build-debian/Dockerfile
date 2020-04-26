FROM ubuntu:18.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

WORKDIR /opt/avertem
ADD avertem /opt/avertem/release/
ADD build.sh /opt/avertem/build.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y fakeroot build-essential dh-make libsnappy-dev zlib1g-dev liblz4-dev libzstd-dev checkinstall libcurl4-openssl-dev libjpeg62-dev libpng-dev libxml2-dev && \
    apt-get clean


CMD tail -f /dev/null


