FROM ubuntu:18.04
MAINTAINER Brett Chaldecott "brett.chaldecott@gmail.com"

RUN apt-get clean && apt-get update \
        && apt-get -y install locales gdebi-core wget \
        && locale-gen en_US.UTF-8 \
        && export KETO_VERSION=$(wget -qO- https://s3-eu-west-1.amazonaws.com/keto-release/linux/ubuntu/latest_version.txt) \
        && wget "https://s3-eu-west-1.amazonaws.com/keto-release/linux/ubuntu/${KETO_VERSION}/keto_${KETO_VERSION}_all.deb" \
        && gdebi -n keto_${KETO_VERSION}_all.deb

#RUN apt-get clean && apt-get update \
    #    && apt-get -y install wget \
    #&& wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    #&& apt-get -y install clang-4.0 lldb-4.0 libclang-4.0-dev cmake make \
    #                             libbz2-dev libssl-dev libgmp3-dev \
    #                             autotools-dev build-essential \
    #                             libbz2-dev libicu-dev python-dev \
    #                             autoconf libtool git curl \
    #                             libgflags-dev libsnappy-dev \
    #                             zlib1g-dev liblz4-dev libzstd-dev \
    #                             bison libbison-dev flex libfl-dev \
    #                             gtk-doc-tools libxml2-dev libdb-dev \
    #                             libpcre3 libpcre3-dev locales \
    #&& locale-gen en_US.UTF-8 \
    #&& export KETO_VERSION=$(wget -qO- https://s3-eu-west-1.amazonaws.com/keto-release/linux/ubuntu/latest_version.txt) \
    #    && wget "https://s3-eu-west-1.amazonaws.com/keto-release/linux/ubuntu/${KETO_VERSION}/keto_${KETO_VERSION}_all.deb" \
    #    && dpkg -i keto_${KETO_VERSION}_all.deb

ADD config/setup_config.sh /opt/keto/setup_config.sh

RUN /opt/keto/setup_config.sh

WORKDIR /opt/keto

CMD /opt/keto/bin/ketod.sh


