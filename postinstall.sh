#!/bin/bash
# Script d’installation et de configuration de base
# Pour Debian/Ubuntu (à exécuter en root)

### Vérification des droits root ###
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté en root (sudo ou connexion root)."
  exit 1
fi

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
  echo " -> 'wins' est déjà présent dans la ligne hosts."
fi

echo "=== Personnalisation du /root/.bashrc (décommenter lignes 9 à 13) ==="
BASHRC="/root/.bashrc"
if [ -f "$BASHRC" ]; then
  cp "$BASHRC" "$BASHRC.bak.$(date +%F-%H%M%S)"
  # Décommente les lignes 9 à 13 (supprime un # en début de ligne si présent)
  sed -i '9,13 s/^#//' "$BASHRC"
  echo " -> Lignes 9 à 13 décommentées (attention : basé sur la numérotation actuelle du fichier)."
else
  echo " -> /root/.bashrc introuvable, rien modifié."
fi

echo "=== Installation de Webmin ==="
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
echo "y" | sh webmin-setup-repo.sh > /dev/null
apt update
apt install webmin --install-recommends -y

echo "=== Installation terminée ==="
echo "Tu peux accéder à Webmin (par défaut https://<IP>:10000)."
