#!/bin/bash
set -e

# --- Étape 1 : Exécution de la commande préalable (sshd.service) ---

# Le CMD (par exemple "sshd.service") est passé comme argument $1 au script.
SERVICE_NAME="$1"

if [ -n "$SERVICE_NAME" ]; then
    echo "Lancement du service Systemd : $SERVICE_NAME"
    # systemctl ne fonctionnera PAS correctement ici car D-Bus n'est pas encore lancé.
    # Nous devons simplement nous assurer que le service est activé pour que systemd le lance
    # lorsqu'il prend le contrôle du PID 1.

    # ⚠️ Solution la plus fiable : utiliser 'systemctl enable' pour s'assurer qu'il démarrera
    # au lancement de systemd.
    /bin/systemctl enable "$SERVICE_NAME" || true
fi

# --- Étape 2 : Lancer systemd et le définir comme PID 1 ---

echo "Transfert du contrôle à Systemd (PID 1)..."
# 'exec' remplace le processus shell actuel (le script) par /usr/sbin/init.
# C'est CRUCIAL pour que systemd devienne le PID 1.
exec /usr/sbin/init