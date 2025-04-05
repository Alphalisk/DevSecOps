#!/bin/bash

# === Instellingen Basis ===
VMID=161 # Dit aanpassen
VMNAME="vm-gitea" # Dit aanpassen
CEPHPOOL="vm-storage"
DISK="vm-${VMID}-disk-0"
CLOUDIMG_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
CLOUDIMG="jammy-server-cloudimg-amd64.img"
IMG_RAW="ubuntu.raw"
IMG_RESIZED="ubuntu-20G.raw"
MEM=2048
CORES=2
IP="10.24.13.161/24" # Dit aanpassen
GW="10.24.13.1"
USER="Dockeradmin"
SSH_PUBKEY_PATH="$HOME/.ssh/id_rsa.pub"

# === Instellingen Tailscale ===
VM_IP="10.24.13.161" # Dit aanpassen
SSH_USER="Dockeradmin"
TAILSCALE_ENV="/tmp/tailscale.env"
VM_HOSTNAME="vm-gitea" # Dit aanpassen

# === Basis installatie VM met Ubuntu ===
echo "📥 Download Ubuntu Cloud Image"
sudo wget -O $CLOUDIMG $CLOUDIMG_URL

echo "🔄 Converteer naar RAW"
sudo qemu-img convert -f qcow2 -O raw $CLOUDIMG $IMG_RAW

echo "📏 Vergroot RAW image naar 20G"
sudo qemu-img resize $IMG_RAW 20G

echo "📤 Upload RAW disk naar Ceph"
sudo rbd rm ${CEPHPOOL}/$DISK 2>/dev/null
sudo rbd import $IMG_RAW $DISK --dest-pool $CEPHPOOL

echo "🖥️ Maak VM aan"
sudo qm create $VMID \
  --name $VMNAME \
  --memory $MEM \
  --cores $CORES \
  --net0 virtio,bridge=vmbr0 \
  --scsihw virtio-scsi-pci \
  --ide2 ${CEPHPOOL}:cloudinit \
  --ostype l26 \
  --agent enabled=1

echo "💾 Koppel disk en stel boot in"
sudo qm set $VMID --scsi0 ${CEPHPOOL}:$DISK
sudo qm set $VMID --boot c --bootdisk scsi0

echo "⚙️ Configureer cloud-init"
sudo qm set $VMID \
  --ciuser $USER \
  --ipconfig0 ip=$IP,gw=$GW \
  --sshkey $SSH_PUBKEY_PATH

# 4. Start de VM
echo "🟢 Start VM $VMID..."
sudo qm start $VMID

# 5. Wacht tot SSH beschikbaar is
echo "⏳ Wachten tot SSH werkt op $IP..."
until ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o BatchMode=yes $USER@${IP%/*} 'echo SSH OK' 2>/dev/null; do
  sleep 3
done

# 6. DNS fix
echo "🌐 DNS instellen op 1.1.1.1"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

# 7. UFW firewall configureren
echo "🛡️ Firewall instellen"
ssh $USER@${IP%/*} << 'EOF'
sudo apt update
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw allow 22 comment 'Allow SSH'
sudo ufw allow 80 comment 'Allow HTTP'
sudo ufw allow 443 comment 'Allow HTTPS'
sudo ufw --force enable
sudo ufw status verbose
EOF

# 8. Update & upgrade uitvoeren
# Hij gaat de eerste keer mis door een blokkade
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"
ssh $USER@${IP%/*} "sudo kill -9 \$(pgrep apt-get)"
ssh $USER@${IP%/*} "sudo dpkg --configure -a"
ssh $USER@${IP%/*} "echo 'nameserver 1.1.1.1' | sudo tee /etc/resolv.conf"

echo "🔄 System update uitvoeren"
ssh $USER@${IP%/*} << 'EOF'
sudo apt update && sudo apt upgrade -y
EOF

# herstarten
sudo qm reboot 142 # Deze veranderen!

# Wacht tot SSH beschikbaar is
echo "⏳ Wachten tot SSH werkt op $IP..."
until ssh -o ConnectTimeout=2 -o StrictHostKeyChecking=no -o BatchMode=yes $USER@${IP%/*} 'echo SSH OK' 2>/dev/null; do
  sleep 3
done

echo "✅ VM $VMID is volledig klaar en geconfigureerd op $IP"

# === installatie Tailscale ===
# 🔑 SSH toegang check
echo "📤 Kopieer Tailscale config naar VM..."
scp $TAILSCALE_ENV ${SSH_USER}@${VM_IP}:/tmp/tailscale.env

# 🚀 Installatie + setup in de VM
ssh ${SSH_USER}@${VM_IP} << 'EOF'
set -e

# 🧪 DNS fix
echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf

# 📦 Installatie Tailscale
source /tmp/tailscale.env
sudo apt update
sudo apt install -y curl jq
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled

# ⏳ Wachten op backend
for i in {1..10}; do
  if tailscale status &>/dev/null; then break; fi
  echo "⏳ Wachten op tailscaled backend..."; sleep 2
done

# 🔐 Verbinden
sudo tailscale up --authkey "$TAILSCALE_AUTH_KEY" --hostname VM-gitea --ssh

# ✅ Status tonen
echo "🌐 Tailscale IP:"; tailscale ip -4 | head -n 1
echo "🔗 DNS naam:"; tailscale status --json | jq -r ".Self.DNSName"
EOF

