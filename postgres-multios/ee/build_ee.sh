#!/bin/bash

# Nom de l'image de l'Execution Environment
EE_IMAGE_NAME="ansible-postgres-ee:latest"
KIND_CLUSTER_NAME="awx"

echo "1. Construction de l'image EE: ${EE_IMAGE_NAME}..."
# Utilisez podman build ou docker build
docker build -t ${EE_IMAGE_NAME}  .

if [ $? -ne 0 ]; then
    echo "Erreur lors de la construction de l'image."
    exit 1
fi

echo "2. Chargement de l'image dans le cluster Kind: ${KIND_CLUSTER_NAME}..."
# Charger l'image dans le nœud du cluster Kind pour qu'elle soit accessible par AWX
kind load docker-image ${EE_IMAGE_NAME} --name ${KIND_CLUSTER_NAME}

if [ $? -ne 0 ]; then
    echo "Erreur lors du chargement de l'image Kind. Assurez-vous que le cluster '${KIND_CLUSTER_NAME}' est en cours d'exécution."
    exit 1
fi

echo "✅ Image ${EE_IMAGE_NAME} chargée avec succès dans Kind."
echo "Prochaine étape: Configurez AWX pour utiliser cette image."