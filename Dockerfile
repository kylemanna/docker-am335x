#
# Toolchain for building kernel and PRU
#
FROM ubuntu:16.04

MAINTAINER Kyle Manna <kyle@kylemanna>

RUN apt-get update && \
    apt-get install -y build-essential git-core gcc-arm-none-eabi \
                       flex bison vim curl libc6-dev-i386 bc ccache lzop && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /build
WORKDIR /build

ENV USE_CCACHE 1
ENV CCACHE_DIR /build/.ccache

# Device Tree Build
RUN git clone -b v1.4.1 https://github.com/RobertCNelson/dtc && \
    cd dtc && \
    make && \
    make check install PREFIX=/usr/local && \
    cd - && \
    rm -rf dtc

# PRU v?.?.?
#RUN git clone https://github.com/beagleboard/am335x_pru_package \
#    && cd am335x_pru_package \
#    && make \
#    && make install \
#    && cd - \
#    && rm -rf am335x_pru_package
#

# TI's PRU Build tools
ENV PRU_CGT /usr/share/ti-cgt-pru_2.1.4
RUN curl -LO http://software-dl.ti.com/codegen/esd/cgt_public_sw/PRU/2.1.4/ti_cgt_pru_2.1.4_linux_installer_x86.bin && \
    chmod +x ti_cgt_pru_2.1.4_linux_installer_x86.bin && \
    ./ti_cgt_pru_2.1.4_linux_installer_x86.bin --mode unattended --prefix /usr/share && \
    cd $PRU_CGT/bin && \
    for i in *; do ln -s $PWD/$i /usr/local/bin/; done && \
    cd - && \
    rm ti_cgt_pru_2.1.4_linux_installer_x86.bin
