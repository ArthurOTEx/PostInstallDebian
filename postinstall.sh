#!/bin/bash
# Script d’installation et de configuration de base
# Pour Debian (à exécuter en root)

echo "=== Mise à jour du système ==="
apt update && apt upgrade -y

echo "=== Installation des paquets de base (binutils & outils réseau) ==="
apt install -y \
  ssh zip nmap locate ncdu curl git screen dnsutils net-tools sudo lynx \
  winbind samba

echo "=== Sauvegarde et modification de /etc/nsswitch.conf (ajout de wins) ==="
if ! grep -q "^hosts:.*wins" /etc/nsswitch.conf; then
  cp /etc/nsswitch.conf /etc/nsswitch.conf.bak.$(date +%F-%H%M%S)
  sed -i '/^hosts:/ s/$/ wins/' /etc/nsswitch.conf
  echo " -> 'wins' ajouté à la ligne hosts."
else
  echo " -> 'wins' déjà présent."
fi

echo "=== Personnalisation du /root/.bashrc (décommenter alias LS) ==="
BASHRC="/root/.bashrc"

if [ -f "$BASHRC" ]; then
    cp "$BASHRC" "$BASHRC.bak.$(date +%F-%H%M%S)"

    sed -i \
        -e "s/^# export LS_OPTIONS='/export LS_OPTIONS='/" \
        -e "s/^# eval \"\$(dircolors)\"/eval \"\$(dircolors)\"/" \
        -e "s/^# alias ls='/alias ls='/" \
        -e "s/^# alias ll='/alias ll='/" \
        -e "s/^# alias l='/alias l='/" \
        "$BASHRC"

    echo " -> Alias ls & dircolors décommentés."
else
    echo " -> /root/.bashrc introuvable, non modifié."
fi


echo "=== Installation de Webmin ==="
curl -fsSL -o /tmp/webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sh /tmp/webmin-setup-repo.sh

apt update
apt install -y webmin --install-recommends

echo ""
echo "==============================================="
echo " Installation terminée !"
echo " Accès Webmin : https://<IP-serveur>:10000"
echo "==============================================="
