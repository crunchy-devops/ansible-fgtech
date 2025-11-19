# Containerfile
# Utilisation de la base CentOS 7 standard
FROM centos:7

# Définition des variables d'environnement
ENV ANSIBLE_PYTHON_INTERPRETER="/usr/bin/python"
ENV ANSIBLE_USER="ansible"

# Définir les variables d'environnement de locale pour forcer UTF-8
ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Définir temporairement ces variables pour le build. Elles seront réinitialisées par le VENV.
# Cela empêche pip de chercher des modules dans les chemins Python 2.7 du système.
ENV PYTHONPATH=""
ENV PYTHONHOME=""
ENV PYTHONSTARTUP=""
ENV PYTHONUSERBASE=""


# Définir le chemin de l'EE pour le venv
ENV VENV_PATH="/usr/local/ee_venv"


# --- PHASE 1 : Configuration du Vault, YUM et Installation de Python 3.9 ---

# 1a. Configuration du Vault et installation de Python 3.9 (via SCL ou paquets)
RUN sed -i 's|^mirrorlist=|#mirrorlist=|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|^#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum makecache

# 1b. Installer les dépendances (Python 3, outils système)
RUN yum install -y epel-release \
    && yum install -y \
    tini \
    ansible \
    git \
    sudo \
    which \
    openssh-clients \
    openssh-server \
    python3 \
    python3-pip \
    # Paquets critiques du système pour Python 2.7.5 (laissé pour le client)
    python \
    python-devel \
    # Nettoyage
    && yum clean all

# --- PHASE 2 : Installation d'Ansible Runner 3.x (sur Python 3) ---


# Créer le VENV sur Python 3 et l'activer
RUN python3 -m venv $VENV_PATH

# Installer la dernière version d'Ansible Runner et forcer Ansible 2.9.27 (installé sur Python 3)
# Utiliser le VENV pour l'installation
RUN source $VENV_PATH/bin/activate && \
    pip install --upgrade pip setuptools && \
    pip install encodings \
    'ansible==2.9.27' \
    'ansible-runner==2.3.2' \
    pyOpenSSL \
    cryptography \
    psutil \
    pexpect \
    PyYAML \
    six \
    enum34 \
    ipaddress \
    cffi \
    idna \
    wheel

# --- PHASE 3 : Finalisation AWX et ENTRYPOINT ---
# L'interpréteur Ansible pointe vers le Python 3 du conteneur.
# Définir les chemins finaux
ENV PATH="$VENV_PATH/bin:$PATH"
ENV ANSIBLE_PYTHON_INTERPRETER="/usr/bin/python"

WORKDIR /opt/app-root/src
USER 1000
# ENTRYPOINT compatible AWX
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/bash"]