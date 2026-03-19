# ctr_ansible_el10

Enterprise Linux 10 (AlmaLinux 10) Docker container for Ansible playbook and role testing with [Molecule](https://molecule.readthedocs.io/).

## Description

This container is based on `almalinux:10` and includes:

- **systemd** – enables testing of services that rely on systemd init
- **Ansible** – installed via [uv](https://github.com/astral-sh/uv) for running playbooks and roles
- Supporting libraries: `python3`, `libffi-devel`, `openssl-devel`, `libyaml-devel`, and more

It is intended to be used as a target container for Molecule-based Ansible role testing.

## Usage

### Pull the image

```bash
docker pull ghcr.io/bnlcyber/ctr_ansible_el10:latest
```

### Run interactively

```bash
docker run --rm -it --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host \
  ghcr.io/bnlcyber/ctr_ansible_el10:latest
```

### Use with Molecule

In your `molecule.yml`, configure the driver to use this image as the platform:

```yaml
platforms:
  - name: instance
    image: ghcr.io/bnlcyber/ctr_ansible_el10:latest
    command: /usr/lib/systemd/systemd
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
    cgroupns_mode: host
    privileged: true
```

## Building locally

```bash
docker build -t ctr-ansible-el10 .
```

## License

BSD 3-Clause – see [LICENSE](LICENSE).