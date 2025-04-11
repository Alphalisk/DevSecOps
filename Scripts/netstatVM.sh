# # purge old netdata
# ssh Dockeradmin@10.24.13.167 << 'EOF'
# sudo systemctl stop netdata || true
# sudo pkill netdata || true
# sudo apt purge --yes netdata netdata-core netdata-web netdata-plugins-* || true
# sudo rm -rf /etc/netdata /var/lib/netdata /var/cache/netdata /opt/netdata /usr/lib/netdata /usr/sbin/netdata
# sudo rm -f /etc/systemd/system/netdata.service
# EOF

# clean install
ssh Dockeradmin@10.24.13.166 << 'EOF'
bash <(curl -SsL https://my-netdata.io/kickstart.sh) --dont-wait
EOF

# Firewall (misschien nodig)
ssh Dockeradmin@10.24.13.166 << 'EOF'
sudo ufw allow 19999/tcp comment 'Allow Netdata'
sudo systemctl restart netdata
EOF

# misschien nodig...
ssh Dockeradmin@10.24.13.166 << 'EOF'
sudo mkdir -p /etc/netdata
sudo sed -i 's/^  bind to = localhost/  bind to = 0.0.0.0/' /etc/netdata/netdata.conf
sudo systemctl restart netdata
EOF
