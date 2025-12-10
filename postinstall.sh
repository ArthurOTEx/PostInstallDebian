#!/bin/bash
# Script d’installation et configuration
# À exécuter en root
clear

echo "=== Mise à jour du système ==="
apt update && apt upgrade -y

echo "=== Installation des paquets système ==="
apt install -y \
  ssh zip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx \
  winbind samba

echo "=== Sauvegarde et modification de /etc/nsswitch.conf (ajout de wins) ==="
if ! grep -q "^hosts:.*wins" /etc/nsswitch.conf; then
  sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf
  echo " -> 'wins' ajouté à la ligne hosts."
else
  echo " -> 'wins' est déjà présent dans la ligne hosts."
fi

echo "=== Personnalisation du /root/.bashrc (décommenter lignes 9 à 13) ==="
echo "" >> ~/.bashrc
echo "# Personnalisation des alias LS" >> ~/.bashrc
echo "export LS_OPTIONS='--color=auto'" >> ~/.bashrc
echo "eval \"\$(dircolors)\"" >> ~/.bashrc
echo "alias ls='ls \$LS_OPTIONS'" >> ~/.bashrc
echo "alias ll='ls \$LS_OPTIONS -l'" >> ~/.bashrc
echo "alias l='ls \$LS_OPTIONS -lA'" >> ~/.bashrc

echo "=== Installation de Webmin ==="
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
echo "y" | sh webmin-setup-repo.sh > /dev/null
apt update
apt install webmin --install-recommends -y

echo "=== Installation terminée ==="
echo "Tu peux accéder à Webmin (par défaut https://<IP>:10000)."
