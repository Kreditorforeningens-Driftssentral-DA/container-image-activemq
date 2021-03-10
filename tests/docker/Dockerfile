# RUNNING
# docker run -d \
# --tty \
# --privileged \
# --volume /sys/fs/cgroup:/sys/fs/cgroup:ro \
# --name ubuntu-systemd \
# local/ubuntu-systemd:latest
# --
FROM ubuntu:latest

ENV container=docker

RUN set -e \
    && echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && sed -i 's/# deb/deb/g' /etc/apt/sources.list \
    && apt-get -y clean \
    && apt-get -y update \
    && apt-get -y install tzdata \
    && apt-get -y install systemd systemd-sysv \
    && apt-get -y install python3-simplejson python3-pip python3-apt sudo curl gzip tar less \
    && apt-get -y autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cd /lib/systemd/system/sysinit.target.wants/ \
    && ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/anaconda.target.wants/* \
    && rm -f /lib/systemd/system/plymouth* \
    && rm -f /lib/systemd/system/systemd-update-utmp*

RUN set -e \
    && mkdir -p /localhome \
    && groupadd --gid 5000 ansible \
    && useradd -b /localhome -m --gid 5000 --uid 5000 -s /bin/bash -c ansible ansible \
    && echo "ansible  ALL=(ALL)  NOPASSWD:ALL" > /etc/sudoers.d/ansible \
    && chmod 600 /etc/sudoers.d/ansible

VOLUME [ "/sys/fs/cgroup" ]

ENTRYPOINT ["/lib/systemd/systemd"]
