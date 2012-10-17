#!/bin/bash

# Script de ejemplo para instalar un nuevo Drupal 7 desde cero

SITEPATH="/var/www/$1"

# Indica el proyecto de Drupal a descargar (drupal, drupal-6, commerce_kickstart ...):
DRUPAL_PROJECT=drupal
#DRUPAL_PROJECT=commerce_kickstart


# Indica el PROFILE de Drupal que se utilizará en la instalación: standard, testing, minimal
PROFILE=standard
#PROFILE=commerce_kickstart

# Como parámetro se le pasará el nombre del nuevo sitio
[ "$#" -eq 1 ] || (echo "1 argumento requerido, $# proporcionados. Indique el nombre del nuevo sitio web sin espacios" ; exit 1)

# Creamos (o reiniciamos) la base de datos
echo "DROP DATABASE IF EXISTS $1" | mysql -u root
mysqladmin -u root create $1
echo "GRANT ALL PRIVILEGES ON $1.* TO $1@localhost IDENTIFIED BY '$1' WITH GRANT OPTION;" | mysql -u root

# Descargamos Drupal Core
echo " * Descargando Drupal core ... "
sudo rm -rf $SITEPATH
drush dl -y $DRUPAL_PROJECT --drupal-project-rename=$1

# Inicializamos la instalación de drupal
echo " * Configurando instalación de Drupal ... "
echo ""
drush --root=$SITEPATH site-install $PROFILE -y --locale=es --account-name=admin --account-pass=admin --db-url=mysql://$1:$1@localhost/$1

# Cambiamos el nombre al sitio para evitar confusiones
drush --root=$SITEPATH --yes vset site_name "$1"

# Ajustando permisos (algunas carpetas se crean con permisos para el usuario en lugar de www)
echo " * Ajustando permisos ..."
echo ""
chmod 777 $SITEPATH/sites/default/files
chmod 777 $SITEPATH/sites/default/files/styles

