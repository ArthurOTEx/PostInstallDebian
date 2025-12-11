#!/bin/bash

echo "=== Mise à jour du système ==="
apt update && apt upgrade -y

echo "=== Installation des paquets utilitaires ==="
apt install -y ssh zip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx

echo "=== Installation de la couche NetBIOS ==="
apt install -y winbind samba

echo "=== Modification du fichier /etc/nsswitch.conf ==="
sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf

echo "=== Personnalisation du BASH pour root ==="
cat << 'EOF' >> /root/.bashrc

# Personnalisation post-install
export LS_OPTIONS='--color=auto'
eval "$(dircolors)"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'
EOF

echo "=== Installation de Webmin ==="
curl -s -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
echo "y" | sh webmin-setup-repo.sh > /dev/null
apt update
apt install webmin --install-recommends -y

echo "=== Installation terminée ==="
echo "=== Webmin (https://<IP>:10000). ==="
