#!/bin/bash

# Script de puesta en marcha de entorno de desarrollo para PHP.
#
# autor: Magdalena Báscones Carrillo
# Modificado por: Rodrigo Saiz Camarero
#
# Este script está pensado para la puesta en marcha de un servidor de
# desarrollo. No usar para servidores en producción.
#

# Actualizamos la información sobre paquetes (opcional)
sudo apt-get update

# LAMP Server (Linux + Apache + Mysql + PHP)
sudo apt-get install -y  lamp-server^

# Ajustamos los permisos para poder escribir en el directorio raiz del servidor.
sudo chmod 777 /var/www

# Dependencias necesarias para Drupal o Drush
sudo apt-get install -y php-pear php5-gd

# php APC: Mejora el rendimiento de PHP.
sudo apt-get install -y php-apc
gzip -dc /usr/share/doc/php-apc/apc.php.gz > /var/www/apc.php # Acceso a estadísticas de APC

# otros programas de utilidad:
sudo apt-get install -y git gitg

# Determinar de forma fiable el nombre del servidor.
# Elimina el error: "...Could not reliably determine the server's fully qualified domain name..."
echo 'ServerName localhost' | sudo tee -a /etc/apache2/httpd.conf > /dev/null

# Eliminamos las restricciones de Apache para que el actue el fichero .htaccess de Drupal
sudo sed -i '11 s/AllowOverride None/AllowOverride All/' /etc/apache2/sites-available/default

# Drush
# http://drupalalsur.org/apuntes/instalar-drush-en-ubuntu#metodo_tres_de_drush
sudo pear channel-discover pear.drush.org
sudo pear install drush/drush
sudo chmod u+x /usr/bin/drush

sudo drush # Ejecutamos Drush una vez como root para que pueda descargarse las dependencias
yo=`whoami`
sudo chown -R $yo /home/$yo/.drush  # Corregimos los permisos.

# Activamos el módulo Url Rewrite de apache necesario para las URLs limpias.
sudo a2enmod rewrite

# Reiniciamos apache.
sudo apache2ctl restart

# Creamos un acceso directo a www
ln -s /var/www/ ~/www
