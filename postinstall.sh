#!/bin/bash
# Script d’installation et configuration
# Compatible Debian / Ubuntu
# À exécuter en root

### Vérification des droits root ###
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en root (sudo ou connexion root)."
  exit 1
fi

echo "=== Mise à jour du système ==="
apt update && apt upgrade -y

echo "=== Installation des paquets système ==="
apt install -y \
  ssh zip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx \
  winbind samba

echo "=== Modification de /etc/nsswitch.conf : ajout de wins ==="
if ! grep -q "^hosts:.*wins" /etc/nsswitch.conf; then
  cp /etc/nsswitch.conf /etc/nsswitch.conf.bak.$(date +%F-%H%M%S)
  sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf
  echo " -> 'wins' ajouté."
else
  echo " -> 'wins' est déjà présent."
fi

echo "=== Personnalisation du /root/.bashrc ==="
BASHRC="/root/.bashrc"
if [ -f "$BASHRC" ]; then
  cp "$BASHRC" "$BASHRC.bak.$(date +%F-%H%M%S)"
  sed -i '9,13 s/^#//' "$BASHRC"
  echo " -> Lignes 9 à 13 décommentées."
else
  echo " -> /root/.bashrc introuvable."
fi

echo "=== Installation de Webmin ==="
curl -fsSL -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh

# Répond automatiquement "y" au script d'installation
printf "y\n" | sh /tmp/webmin-setup-repo.sh

apt update
apt install -y webmin --install-recommends

echo "=== Installation terminée ==="
echo "Webmin est accessible sur : https://$(hostname -I | awk '{print $1}'):10000"
