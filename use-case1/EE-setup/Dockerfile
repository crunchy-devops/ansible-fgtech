# Dockerfile DinD pour AWX (AlmaLinux 9) avec Systemd
FROM almalinux:9

# 1. Définitions d'environnement et PATH
ENV container docker \
    LANG='en_US.utf8' \
    LC_ALL='en_US.utf8' \
    PATH="/usr/local/bin:/usr/bin:$PATH" \
    DOCKER_CONTENT_TRUST=0

# 2. Installation des dépendances système, systemd, et Docker
RUN dnf -y update \
    # 🚨 CORRECTION: Installer 'dnf-utils' (qui fournit 'config-manager')
    && dnf install -y python3-pip python3-devel gcc git tar unzip wget procps initscripts dnf-utils \
    # Configuration du dépôt Docker
    && dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo \
    # Installation des paquets Docker
    && dnf install -y docker-ce docker-ce-cli containerd.io \
    && dnf clean all

# 3. Création de l'utilisateur AWX (UID 1000) et configuration Systemd
RUN groupadd -g 1000 awx \
    && useradd -u 1000 -g awx -m -s /bin/bash awx \
    && mkdir -p /opt/app-root/src \
    && chown 1000:1000 /opt/app-root/src \
    && usermod -aG docker awx \
    # Nettoyage minimal pour systemd (nécessaire pour éviter les conflits de PID 1)
    && (cd /lib/systemd/system/sysinit.target.wants/;\
    for i in *; do [ $i = systemd-tmpfiles-setup.service ] || rm -f $i; done) \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/*

# 4. Installation des dépendances Python (Ansible, Tox, Molecule)
USER awx
WORKDIR /opt/app-root/src
RUN pip3 install --no-cache-dir \
    ansible-core \
    ansible-runner \
    tox \
    molecule \
    ansible-lint \
    testinfra \
    docker

# 5. Point d'entrée pour le mode Systemd (pour PID 1)
USER root
CMD ["/usr/sbin/init"]