FROM oraclelinux:7.9 as build

ENV git git-2.9.5
ENV go go1.20.5

RUN yum -y install oracle-golang-release-el7 oracle-release-el7 && \
    yum-config-manager --disable ol7_developer_golang\* && \
    yum-config-manager --enable ol7_developer_golang118 && \
    yum -y install golang make \
      curl-devel expat-devel gettext-devel openssl-devel zlib-devel \
      gcc perl-ExtUtils-MakeMaker && \
    rm -rf /var/cache/yum/*

ADD $git.tar.gz /build
RUN cd /build/$git/ && \
    make prefix=/usr/local/git all install && \
    yum -y remove git

ENV PATH="/usr/local/git/bin:$PATH"

ADD $go.src.tar.gz /build

RUN cd /build/go/src && \
    /bin/bash make.bash

FROM oraclelinux:7.9

COPY --from=build /usr/local/git /opt/git
COPY --from=build /build/go /opt/go
ENV PATH="/opt/git/bin:/opt/go/bin:/opt/node/bind:$PATH"

RUN yum -y install make && \
    groupadd --gid 1000 user && \
    adduser --uid 1000 --gid user user 

USER user
