FROM almalinux:10
LABEL maintainer="BNLCyber"

ENV uv_packages="ansible"

# Install uv from the official image.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Install systemd -- See https://hub.docker.com/_/centos/
RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install dependencies.
RUN dnf -y update \
    && dnf -y install \
       gcc \
       glibc-langpack-en \
       hostname \
       initscripts \
       libffi-devel \
       openssl-devel \
       libyaml-devel \
       python3-devel \
       python3-setuptools \
       python3-pyyaml \
       sudo \ 
       iproute \
       gnupg2 \
       which \
    && dnf clean all 

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible via uv.
RUN uv pip install --system $uv_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
