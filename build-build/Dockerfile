FROM ubuntu:16.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

WORKDIR /opt/keto
ADD install_dependencies.sh /opt/keto/install_dependencies.sh

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get -y install wget \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get -y install clang-4.0 lldb-4.0 libclang-4.0-dev cmake make \
                                 libbz2-dev libssl-dev libgmp3-dev \
                                 autotools-dev build-essential \
                                 libbz2-dev libicu-dev python-dev \
                                 autoconf libtool git curl \
                                 libgflags-dev libsnappy-dev \
                                 zlib1g-dev liblz4-dev libzstd-dev \
                                 bison libbison-dev flex libfl-dev \
                                 gtk-doc-tools libxml2-dev libdb-dev \
                                 libpcre3 libpcre3-dev locales gdb \
    && locale-gen en_US.UTF-8 \
    && /opt/keto/install_dependencies.sh


CMD tail -f /dev/null


