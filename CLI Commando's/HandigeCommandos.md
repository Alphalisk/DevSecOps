
# Permanente DNS fix
sudo nano /etc/systemd/resolved.conf

# in nano file toevoegen:
[Resolve]
DNS=8.8.8.8 1.1.1.1
FallbackDNS=9.9.9.9
DNSStubListener=no

sudo systemctl restart systemd-resolved
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

---