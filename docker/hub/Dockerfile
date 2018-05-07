FROM centos:7
MAINTAINER Bryan Morrow <bryan.morrow@ca.com>

RUN mkdir -p /opt
COPY install /opt

RUN yum -y update \
 && yum -y install \
        java-1.8.0-openjdk \
        net-tools \
        passwd \
        sshpass \
        openssh-clients \
        rsync \
        curl \
        wget \
        tar \
        initscripts \
        telnet \
        git \
        mysql \
 && yum clean all \
 && rm -rf /var/cache/yum

RUN echo 'export JAVA_HOME=/usr/lib/jvm/jre-openjdk' >> ~/.bashrc \
 && echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc \
 && source ~/.bashrc

VOLUME ["/opt/nimsoft"]

RUN chmod +x /opt/installHub.sh

ENTRYPOINT ["/opt/installHub.sh"]
