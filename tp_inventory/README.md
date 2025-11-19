# TP inventaire

## Niveau 1 : Inventaire Statique Basique (Fichier INI)
Créez un fichier nommé inventory_simple.ini. Nous allons définir deux groupes: webservers et databases.  
voir le fichier inventory_simple.ini

### Test de Connectivité Ad-hoc
Vérifier tous les hôtes définis
ansible all -i inventory_simple.ini -m ping

Vérifier uniquement le groupe webservers
ansible webservers -i inventory_simple.ini -m ping

Vérifier un hôte spécifique
ansible db01 -i inventory_simple.ini -m ping

## Niveau 2 : Variables d'Inventaire et Structure YAML
### Étape 2.1 : Conversion en Format YAML
Créez un répertoire inventory_yaml et les fichiers suivants pour organiser les   
hôtes et les variables.
```shell
mkdir -p inventory_yaml
touch inventory_yaml/hosts.yml
mkdir -p inventory_yaml/group_vars
touch inventory_yaml/group_vars/webservers.yml
```
Fichier : inventory_yaml/hosts.yml (Définition des hôtes)



