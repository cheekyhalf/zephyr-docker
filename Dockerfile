FROM phusion/baseimage:0.9.18
MAINTAINER marshall@kubos.co

ARG SDK_VERSION=0.9

ENV ZEPHYR_BASE            /build
ENV PATH                   $PATH:$ZEPHYR_BASE/scripts
ENV ZEPHYR_SDK_SETUP       zephyr-sdk-$SDK_VERSION-setup.run
ENV ZEPHYR_GCC_VARIANT     zephyr
ENV ZEPHYR_SDK_INSTALL_DIR /opt/zephyr-sdk

RUN mkdir /build

RUN apt-get update
RUN apt-get install -y wget git make gcc gcc-multilib g++ libc6-dev-i386 g++-multilib python cmake libtool autoconf libglib2.0-dev libpcap-dev
RUN cd /tmp
RUN git clone https://gerrit.zephyrproject.org/r/net-tools 
RUN make -C /tmp/net-tools
ADD https://nexus.zephyrproject.org/content/repositories/releases/org/zephyrproject/zephyr-sdk/$SDK_VERSION/$ZEPHYR_SDK_SETUP /tmp
RUN chmod 755 /tmp/$ZEPHYR_SDK_SETUP
RUN /tmp/$ZEPHYR_SDK_SETUP
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /build
WORKDIR /build
ENTRYPOINT ["/sbin/my_init"]
