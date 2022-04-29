#!/bin/bash

echo "**Aprovisionamiento HAPROXY**"

echo "**Recursos necesarios**"
sudo apt install -y vim net-tools
sudo snap install lxd -y

echo "**Creando nuevo grupo**"
newgrp lxd

echo "**Inicializar LXD**"
lxd init --auto

echo "**Sleep**"
sleep 10

echo "**Creando contenedor HAproxy**"
lxc init ubuntu:20.04 HAproxy

echo "**Sleep**"
sleep 15

echo "**Iniciando el HAproxy**"
lxc start HAproxy

echo "**Sleep**"
sleep 10

echo "**Ingresando al shell de HAproxy y ejecutar**"
lxc exec HAproxy -- apt update && apt upgrade -y
lxc exec HAproxy -- apt-get install haproxy -y
lxc exec HAproxy -- systemctl enable haproxy

echo "**Sleep**"
sleep 5

echo "**Archivo de configuracion**"
sudo lxc file push /vagrant/HAproxyfolder/haproxy.cfg HAproxy/etc/haproxy/

echo "**Sleep**"
sleep 5

echo "**Restart del servicio**"
sudo lxc exec HAproxy -- sudo systemctl restart haproxy

echo "**Sleep**"
sleep 10

echo "**Configurando puertos**"
#sudo systemctl stop apache2
#sleep 10
sudo lxc config device add HAproxy proxy80 proxy listen=tcp:192.168.70.4:80 connect=tcp:127.0.0.1:80

echo "**Pagina de error***"
sudo sudo lxc file push /vagrant/HAproxyfolder/503.http HAproxy/etc/haproxy/errors/

echo "**Reiniciando Servicio para ser usado**"
sudo lxc exec HAproxy -- sudo systemctl restart haproxy

echo "Aprovisionamiento Completado (*_*) "
echo "Puede continuar con las operaciones"

