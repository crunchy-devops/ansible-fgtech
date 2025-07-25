FROM almalinux:9

LABEL maintainer='Anton Melekhin'

ENV container=docker
ENV ROOT_PASSWORD="12345678"

RUN dnf update -y && dnf install epel-release -y

RUN INSTALL_PKGS='findutils glibc-common initscripts iproute git vim htop python3 openssh-server openssh-clients sudo' \
    && dnf makecache && dnf install -y $INSTALL_PKGS \
    && dnf clean all

# install puppet agent
RUN dnf install https://yum.puppet.com/puppet8-release-el-9.noarch.rpm -y \
    && dnf install puppet-agent -y


# install ssh server
RUN echo "root:${ROOT_PASSWORD}" | chpasswd && \
    # Permit root login with password (INSECURE for production)
    sed -i 's/^#?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#?PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^#?ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config && \
    # Generate SSH host keys. This will be done on first boot by systemd, but we do it here for non-systemd supervisor.
    # However, sshd service unit in systemd-based images often handles this.
    # For supervisor, we need to ensure they are present or generated by sshd on its first start.
    # The /usr/sbin/sshd -D command will generate them if they don't exist.
    # Alternatively, explicitly generate them:

RUN find /etc/systemd/system \
    /lib/systemd/system \
    -path '*.wants/*' \
    -not -name '*journald*' \
    -not -name '*systemd-tmpfiles*' \
    -not -name '*systemd-user-sessions*' \
    -print0 | xargs -0 rm -vf

VOLUME [ "/sys/fs/cgroup" ]
EXPOSE 22
ENTRYPOINT [ "/usr/sbin/init" ]


