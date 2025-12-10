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
BASHRC="/root/.bashrc"   # change en ~/.bashrc si besoin

echo "Mise à jour de $BASHRC"

# 1) export LS_OPTIONS
if grep -qxF "export LS_OPTIONS='--color=auto'" "$BASHRC"; then
    echo "Ligne déjà présente : export LS_OPTIONS"
else
    echo "export LS_OPTIONS='--color=auto'" >> "$BASHRC"
    echo "Ajout : export LS_OPTIONS"
fi

# 2) eval "$(dircolors)"
if grep -qxF 'eval "$(dircolors)"' "$BASHRC"; then
    echo "Ligne déjà présente : eval dircolors"
else
    echo 'eval "$(dircolors)"' >> "$BASHRC"
    echo "Ajout : eval dircolors"
fi

# 3) alias ls
if grep -qxF "alias ls='ls \$LS_OPTIONS'" "$BASHRC"; then
    echo "Ligne déjà présente : alias ls"
else
    echo "alias ls='ls \$LS_OPTIONS'" >> "$BASHRC"
    echo "Ajout : alias ls"
fi

# 4) alias ll
if grep -qxF "alias ll='ls \$LS_OPTIONS -l'" "$BASHRC"; then
    echo "Ligne déjà présente : alias ll"
else
    echo "alias ll='ls \$LS_OPTIONS -l'" >> "$BASHRC"
    echo "Ajout : alias ll"
fi

# 5) alias l
if grep -qxF "alias l='ls \$LS_OPTIONS -lA'" "$BASHRC"; then
    echo "Ligne déjà présente : alias l"
else
    echo "alias l='ls \$LS_OPTIONS -lA'" >> "$BASHRC"
    echo "Ajout : alias l"
fi

echo "=== Installation de Webmin ==="
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
echo "y" | sh webmin-setup-repo.sh > /dev/null
apt update
apt install webmin --install-recommends -y

echo "=== Installation terminée ==="
echo "Tu peux accéder à Webmin (par défaut https://<IP>:10000)."
