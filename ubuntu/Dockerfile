FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago

# Copy the default shell skeleton to root
RUN cp -r /etc/skel/. ~/

# Let systemd knows it is containerized
ENV container docker

# Enable apt repositories
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# Install systemd and dependencies
RUN apt-get update ; \
    apt-get install -y systemd systemd-sysv ; \
    apt-get clean ; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ; \

# Configure minimal systemd services
RUN cd /lib/systemd/system/sysinit.target.wants/ ; \
    ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 ; \
    rm -f /lib/systemd/system/multi-user.target.wants/* ; \
    rm -f /etc/systemd/system/*.wants/* ; \
    rm -f /lib/systemd/system/local-fs.target.wants/* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev* ; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl* ; \
    rm -f /lib/systemd/system/basic.target.wants/* ; \
    rm -f /lib/systemd/system/anaconda.target.wants/* ; \
    rm -f /lib/systemd/system/plymouth* ; \
    rm -f /lib/systemd/system/systemd-update-utmp*

# Add the wsl.conf to boot with systemd
ADD wsl.conf /etc/wsl.conf
