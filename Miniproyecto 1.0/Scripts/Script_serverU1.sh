#!/bin/bash

echo "Aprovisionamiento servidorU1"

echo "**Recursos necesarios**"
sudo apt install -y vim net-tools
sudo snap install lxd -y

echo "**Creando nuevo grupo**"
newgrp lxd

echo "**Inicializar LXD**"
lxd init --auto

echo "**Sleep**"
sleep 15

echo "**Creando contenedor servidor1**"
lxc launch ubuntu:20.04 servidor1 --target servidoru1

echo "**Sleep**"
sleep 15

echo "**Iniciando el servidor1**"
lxc start servidor1

echo "**Sleep**"
sleep 15

echo "**Ingresando al shell de servidor1 y ejecutar**"
lxc exec servidor1 -- apt update && apt upgrade -y
lxc exec servidor1 -- apt-get install apache2 -y
lxc exec servidor1 -- systemctl enable apache2

echo "**Sleep**"
sleep 5

echo "**Generando Index.html**"
lxc file push /vagrant/servidor1folder/index.html servidor1/var/www/html/index.html

echo "**Restart del servicio1**"
lxc exec servidor1 -- systemctl restart apache2

echo "**Sleep**"
sleep 10

echo "**Configurando puertos**"
sudo systemctl stop apache2
sleep 10
sudo lxc config device add servidor1 server80 proxy listen=tcp:192.168.70.2:80 connect=tcp:127.0.0.1:80

echo "------------------------------------------"

echo "**Creando Backup servidor1**"
lxc launch ubuntu:20.04 Bservidor1 --target servidoru1

echo "**Sleep**"
sleep 15

echo "**Iniciando el Bservidor1**"
lxc start Bservidor1

echo "**Sleep**"
sleep 10

echo "**Ingresando al shell de Bservidor1 y ejecutar**"
lxc exec Bservidor1 -- apt update && apt upgrade -y
lxc exec Bservidor1 -- apt-get install apache2 -y
lxc exec Bservidor1 -- systemctl enable apache2

echo "**Sleep**"
sleep 5

echo "**Generando Index.html**"
lxc file push /vagrant/servidor1folder/index.html Bservidor1/var/www/html/index.html

echo "**Restart del Bservicio**"
lxc exec Bservidor1 -- systemctl restart apache2

echo "**Sleep**"
sleep 10

echo "**Configurando puertos**"
sudo systemctl stop apache2
sleep 10
sudo lxc config device add Bservidor1 server80 proxy listen=tcp:192.168.70.2:1080 connect=tcp:127.0.0.1:80

echo "Aprovisionamiento Completado (~_~)"