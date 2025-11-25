# Base l'image sur l'EE minimal d'Ansible
ARG EE_BASE_IMAGE=quay.io/ansible/ansible-runner:latest
FROM ${EE_BASE_IMAGE}

# Définir l'utilisateur pour l'installation
USER root

# Chemin standard pour les dépendances
WORKDIR /tmp/requirements

# Copier le fichier de collections et l'installer
COPY requirements.yml .
RUN ansible-galaxy collection install -r requirements.yml --collections-path /usr/share/ansible/collections

# S'assurer que les permissions sont bonnes et revenir à l'utilisateur de base
RUN chown -R 1000:0 /usr/share/ansible/collections
USER 1000