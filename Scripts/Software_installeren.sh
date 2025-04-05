#!/bin/bash

IP="10.24.13.161" # Deze veranderen!
USER="Dockeradmin"

# 6. DNS fix
echo "🌐 DNS instellen op 1.1.1.1"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

echo "🔧 Docker prerequisites installeren..."
ssh ${USER}@${IP} << 'EOF'
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt update
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
EOF

echo "🌐 DNS instellen op 1.1.1.1"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

echo "🔐 Docker GPG key toevoegen..."
ssh ${USER}@${IP} << 'EOF'
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null
EOF

echo "➕ Docker repository toevoegen..."
ssh ${USER}@${IP} << 'EOF'
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
EOF

echo "📦 Docker installeren..."
ssh ${USER}@${IP} << 'EOF'
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
EOF

# DNS fixen
ssh ${USER}@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf > /dev/null"


echo "🚀 Docker starten & toevoegen aan groep"
ssh ${USER}@${IP} << EOF
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker << EONG
echo "🐳 Docker toegang getest:"
docker ps
EONG
EOF

echo "✅ Docker installatie klaar! Reboot de VM om docker zonder sudo te gebruiken."

ssh $USER@${IP%/*} "mkdir -p ~/gitea && cd ~/gitea"

echo "📦 Gitea Docker container aanmaken..."
ssh $USER@${IP%/*} << EOF
mkdir -p ~/gitea
cat << 'COMPOSE' > ~/gitea/docker-compose.yml
version: '3'

services:
  gitea:
    image: gitea/gitea:latest
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__server__ROOT_URL=http://$IP:3000/
    volumes:
      - ./gitea:/data
    ports:
      - "3000:3000"
      - "2222:22"
    restart: always
COMPOSE

echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf > /dev/null
cd ~/gitea
docker-compose up -d
EOF

echo "✅ Gitea zou nu moeten draaien op http://$IP:3000"
