  FROM centos:latest
MAINTAINER Bryan Morrow <bryan.morrow@ca.com>
LABEL Vendor="CentOS" \
      License=GPLv2 \
      Version=2.4.6-40

ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME ["/sys/fs/cgroup"]
CMD ["/usr/sbin/init"]

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install net-tools && \
    yum -y --setopt=tsflags=nodocs install telnet && \
    yum -y --setopt=tsflags=nodocs install initscripts && \
    yum clean all

EXPOSE 49000-49025

ADD nimsoft-robot.x86_64.rpm /opt/nimsoft-robot.x86_64.rpm
ADD nms-robot-vars.cfg /opt/nms-robot-vars.cfg

RUN rpm -ivh /opt/nimsoft-robot.x86_64.rpm --prefix=/opt
RUN /opt/nimsoft/install/RobotConfigurer.sh
RUN systemctl enable nimbus.service
