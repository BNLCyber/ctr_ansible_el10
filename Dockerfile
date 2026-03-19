FROM almalinux:10
LABEL maintainer="BNLCyber"

ENV uv_packages="ansible"

# Install uv from the official image.
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Install dependencies.
RUN dnf -y update \
    && dnf -y install \
       gcc \
       glibc-langpack-en \
       libffi-devel \
       openssl-devel \
       libyaml-devel \
       python3-devel \
       python3-setuptools \
       python3-yaml \
       rsyslog systemd sudo iproute \
    && dnf clean all \
    && rm -rf /var/cache/dnf \
    && rm -rf /usr/share/doc /usr/share/man

RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Install Ansible via uv.
RUN uv pip install --system $uv_packages

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible \
    && echo -e "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
    && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/usr/lib/systemd/systemd"]
