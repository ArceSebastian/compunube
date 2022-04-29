#!/bin/bash

echo "Aprovisionamiento servidorU2"

echo "**Recursos necesarios**"
sudo apt install -y vim net-tools
sudo snap install lxd -y

echo "**Creando nuevo grupo**"
newgrp lxd

echo "**Inicializar LXD**"
lxd init --auto

echo "**Sleep**"
sleep 15

echo "**Creando contenedor servidor2**"
lxc init ubuntu:20.04 servidor2 --target servidoru2

echo "**Sleep**"
sleep 15

echo "**Iniciando el servidor2**"
lxc start servidor2

echo "**Sleep**"
sleep 15

echo "**Ingresando al shell de servidor1 y ejecutar**"
lxc exec servidor2 -- apt update && apt upgrade -y
lxc exec servidor2 -- apt-get install apache2 -y
lxc exec servidor2 -- systemctl enable apache2

echo "**Sleep**"
sleep 5

echo "**Generando Index.html**"
lxc file push /vagrant/servidor2folder/index.html servidor2/var/www/html/index.html

echo "**Restart del servicio2**"
lxc exec servidor2 -- systemctl restart apache2

echo "**Sleep**"
sleep 10

echo "**Configurando puertos**"
sudo systemctl stop apache2
sleep 10
sudo lxc config device add servidor2 server280 proxy listen=tcp:192.168.70.3:80 connect=tcp:127.0.0.1:80

echo "------------------------------------------"

echo "**Creando Backup servidor2**"
lxc init ubuntu:20.04 Bservidor2 --target servidoru2

echo "**Sleep**"
sleep 15

echo "**Iniciando el Bservidor2**"
lxc start Bservidor2

echo "**Sleep**"
sleep 10

echo "**Ingresando al shell de Bservidor2 y ejecutar**"
lxc exec Bservidor2 -- apt update && apt upgrade -y
lxc exec Bservidor2 -- apt-get install apache2 -y
lxc exec Bservidor2 -- systemctl enable apache2

echo "**Sleep**"
sleep 5

echo "**Generando Index.html**"
lxc file push /vagrant/servidor2folder/index.html Bservidor2/var/www/html/index.html

echo "**Restart del Bservicio**"
lxc exec Bservidor2 -- systemctl restart apache2

echo "**Sleep**"
sleep 10

echo "**Configurando puertos**"
sudo systemctl stop apache2
sleep 10
sudo lxc config device add Bservidor2 server280 proxy listen=tcp:192.168.70.3:1080 connect=tcp:127.0.0.1:80

echo "Aprovisionamiento Completado (~_~)"