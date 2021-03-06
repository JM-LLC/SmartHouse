#! /bin/bash

# Installation des PiHomie Controllers
# auf einem Raspian Stretch (Lite)

# Sudo Check:
if [ "$(whoami)" != "root" ]; then
	echo "Dieses Skript muss mit 'sudo' oder als 'root' ausgeführt werden !"
	exit 1
fi

# Zusätzliche Konfigurationsmodule können hier eingehängt werden:
modules=()

SCRIPT_PATH="`dirname \"$0\"`"
SCRIPT_PATH="`( cd \"$SCRIPT_PATH\" && pwd )`"
ROOT_PATH="`( cd \"$SCRIPT_PATH/..\" && pwd )`"
HOSTNAME="HomieController"
LOGPATH="/var/log/pihomie"
PORT="5000"


echo
echo "================================"
echo "====== PiHomie Installtion ====="
echo "================================"
echo "           Controller"
echo "--------------------------------"
echo
echo "Module:"
echo "- Core (Apache2, Python 3 Frameworks)"

for m in "${modules[@]}"
do
	echo "- $m"
done


# =============================
# Benutzervariablen
# =============================

echo
echo "> Gib den Hostname für dieses System ein oder lasse ihn leer, um ihn nicht zu ändern - [ENTER]"
read user_hostname
if [[ ! -z "$user_hostname" ]]; then
	HOSTNAME=$user_hostname
	hostname -b $HOSTNAME
	sed -i -e "/127\.0\.1\.1/ s/.*/127\.0\.1\.1\t${HOSTNAME}/g" /etc/hosts
fi


# =============================
# Start des Core-Moduls
# =============================

echo
echo "=> Starte Modul Core"
echo

# Pakete
apt update && apt upgrade -y
apt install -y \
	python3-pip python3-requests \
	apache2 libapache2-mod-wsgi-py3

python3 -m pip install \
	requests flask flask-sqlalchemy pycrypto

#apt autoremove -y


# Benutzer und Rechte für PiHomie
mkdir -p $LOGPATH
addgroup pihomie
adduser --no-create-home --disabled-login --ingroup pihomie --gecos "" pihomie
usermod -a -G www-data pihomie

chown pihomie:www-data -R $LOGPATH
chmod 665 -R $LOGPATH
chown pihomie:www-data -R $ROOT_PATH

cd $ROOT_PATH


# Konfigurationen

# -- Apache2
a2enmod wsgi
sed -i -e "s/Listen\ 80/Listen\ 80\nListen\ 5000/" /etc/apache2/ports.conf
sed -i -e "s|%%HOSTNAME%%|${HOSTNAME}|" $SCRIPT_PATH/apache_vhost.conf
sed -i -e "s|%%PORT%%|${PORT}|" $SCRIPT_PATH/apache_vhost.conf
sed -i -e "s|%%PIHOMIE_ROOT%%|${ROOT_PATH}/controller|" $SCRIPT_PATH/apache_vhost.conf
sed -i -e "s|%%PIHOMIE_GATEWAY%%|${ROOT_PATH}/controller/gateway.wsgi|" $SCRIPT_PATH/apache_vhost.conf
cp $SCRIPT_PATH/apache_vhost.conf /etc/apache2/sites-available/${HOSTNAME}.conf
a2ensite pihomie
service apache2 reload

echo
echo "--- Modul Core erfolgreich eingerichtet ! ---"
echo


# =============================
# Start der zusätzlichen Module:
# =============================
for m in "${modules[@]}"
do
	echo
	echo "=> Starte Modul $m"
	echo

	# ...do stuff...
	
	echo
	echo "--- Modul $m erfolgreich eingerichtet ! ---"
	echo
done


# =============================
# Ende:
# =============================
echo
echo "================================"
echo "PiHomie Controller wurde"
echo "erfolgreich eingerichtet !"
echo "================================"
echo
