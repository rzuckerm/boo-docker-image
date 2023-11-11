FROM ubuntu:18.04

COPY BOO_* /tmp/
ENV MCS_PATH=/usr/bin/mcs
ENV MONO_PATH=/usr/bin/mono
ENV MONO_VERSION=4.6.2
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git mono-devel && \
    mkdir -p /opt && \
    cd /opt && \
    git clone https://github.com/boo-lang/boo && \
    cd boo && \
    git reset --hard $(cat /tmp/BOO_COMMIT_HASH) && \
    cp -pf bin/* /usr/local/bin/ && \
    cd /usr/local/bin && \
    for f in booc booi booish; \
    do \
        printf '#!/bin/sh\nenv mono /usr/local/bin/%s.exe "$@"\n' $f >$f && \
        chmod +x $f; \
    done && \
    rm -rf /opt/boo && \
    apt-get remove -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
