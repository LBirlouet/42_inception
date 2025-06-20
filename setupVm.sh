#!/bin/bash

# Ajouter l USER au sudoers
sudo usermod -aG sudo $USER

# Mettre à jour les listes de paquets
sudo apt update
sudo apt upgrade -y

# installer make et git
sudo apt install make git -y

# Installer les paquets nécessaires pour ajouter des dépôts HTTPS
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release -y

# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Configurer le dépôt stable de Docker
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mettre à jour les listes de paquets à nouveau et installer Docker Engine, containerd et Docker Compose
sudo apt update

sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

# Ajouter votre utilisateur au groupe docker pour pouvoir exécuter docker sans sudo
sudo usermod -aG docker $USER

# Déconnectez-vous et reconnectez-vous pour que les changements de groupe prennent effet

# Ajouter la config de l Host pour redirection localhost vers lbirloue.42.fr
sudo echo "127.0.0.1 lbiroue.42.fr" >> /etc/hosts