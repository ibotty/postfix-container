FROM centos:7
MAINTAINER Tobias Florek tob@butter.sh

EXPOSE 25/tcp 587/tcp

RUN set -x \
 && rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7 \
 && yum --setopt=tsflags=nodocs -y install epel-release \
 && rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
 && yum --setopt=tsflags=nodocs -y install \
        postfix postgrey pypolicyd-spf \
 && yum clean all \
 && for svc in postfix postgrey; do \
        systemctl enable "$svc"; \
    done

# log only config messages
CMD ["/usr/sbin/init"]

# systemd compatible stop sig
STOPSIGNAL RTMIN+3

VOLUME ["/etc/postfix", "/var/spool/postfix"]
