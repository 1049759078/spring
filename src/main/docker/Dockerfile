# This dockerfile build for CMA-IT.
# VERSION 1.0
# Author: c0214

FROM docker.losp.site/lib/hsf-web:v2.0

MAINTAINER chenjun <chenj@dtdream.com>

ADD *.war /home/tomcat/deploy/ROOT.war

RUN mkdir -p /opt/dop/front/ && \
    cd /opt/dop/front/ && \
    curl -s http://zeta.tesir.top/cmait-eu/front/cms.tar.gz | tar xz
