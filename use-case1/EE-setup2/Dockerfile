# Base : CentOS 7
FROM centos:7

# --- PHASE 1 : Préparation du Système et Compilation de Python 2.7.5 ---

# Installer les outils de compilation et de téléchargement essentiels
RUN yum install -y \
    wget \
    gcc \
    make \
    zlib-devel \
    bzip2-devel \
    openssl-devel \
    libffi-devel \
    git \
    tar \
    which \
    && yum clean all

WORKDIR /usr/src
# Télécharger les sources de Python 2.7.5
RUN wget https://www.python.org/ftp/python/2.7.5/Python-2.7.5.tgz \
    && tar xzf Python-2.7.5.tgz

WORKDIR /usr/src/Python-2.7.5
# Configuration et compilation de Python 2.7.5 dans un emplacement standard
# Utilisation de 'altinstall' pour ne pas écraser un éventuel /usr/bin/python existant
RUN ./configure --enable-unicode=ucs4 \
    && make \
    && make altinstall

# Le nouvel exécutable est maintenant à /usr/local/bin/python2.7

# --- PHASE 2 : Installation d'Ansible 2.9.13 ---

# 1. Installer/rétrograder les outils de packaging sur le Python 2.7 compilé
# Utilisation de 'python2.7' pour s'assurer d'utiliser notre version compilée.
RUN /usr/local/bin/python2.7 -m ensurepip \
    && /usr/local/bin/pip2.7 install --upgrade pip==20.3.4 setuptools==44.1.1

# 2. Installer Ansible 2.9.13 et les dépendances compatibles Python 2.7
RUN /usr/local/bin/pip2.7 install \
    ansible==2.9.13 \
    jinja2==2.11.3 \
    markupsafe==1.1.1

# --- PHASE 3 : Finalisation AWX ---

# Configuration utilisateur
RUN groupadd -r ansible && useradd -r -g ansible -u 1000 ansible
USER 1000

# Définir l'interpréteur Python que l'EE doit utiliser pour toutes les tâches
# Le chemin change pour refléter notre installation compilée.
ENV ANSIBLE_PYTHON_INTERPRETER="/usr/local/bin/python2.7"