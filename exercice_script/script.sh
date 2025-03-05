#!/bin/bash

echo "C'est parti, on télécharge le mnt"

wget https://data.geopf.fr/telechargement/download/BDALTI/BDALTIV2_2-0_25M_ASC_LAMB93-IGN69_D009_2023-10-04/BDALTIV2_2-0_25M_ASC_LAMB93-IGN69_D009_2023-10-04.7z


echo "Téléchargement ok, on va dézipper"

#Installer le logiciel qui va dézipper >  sudo apt install p7zip
#Puis dézipper le contenu

p7zip -d BDALTIV2_2-0_25M_ASC_LAMB93-IGN69_D009_2023-10-04.7z

echo "Parfait, on continue avec les départements, mais petite impro,
on va récupérer le département choisi directement avec ogr2ogr !"

ogr2ogr -s_srs EPSG:4326 -t_srs EPSG:2154 -f "ESRI Shapefile" dept_09.shp WFS:https://data.geopf.fr/wfs/wfs?SERVICE=WFS LIMITES_ADMINISTRATIVES_EXPRESS.LATEST:departement -where "insee_dep='09'"

echo "Normalement c'est ok, on a notre shape du département d'intérêt"

echo "Création du vrt des dalles mnt .asc du département, normalement en 2154"

gdalbuildvrt -a_srs EPSG:2154 mnt_09.vrt BDALTIV2_2-0_25M_ASC_LAMB93-IGN69_D009_2023-10-04/BDALTIV2/1_DONNEES_LIVRAISON_2024-02-00018/BDALTIV2_MNT_25M_ASC_LAMB93_IGN69_D009/*.asc

echo "là on a ce qu'il nous faut pour découper les dalles mnt asemblée dans le vrt par le vecteur du département"

gdalwarp -s_srs EPSG:2154 -cutline dept_09.shp -crop_to_cutline mnt_09.vrt crop_mnt_09.vrt

echo "Ok, maintenant on créer le vecteur des courbes de niveau"

gdal_contour -a elev -i 50 crop_mnt_09.vrt courbes_niveau_09.shp

echo "ok, on passe à la base de données"

psql -U user -h 192.168.10.23 -p 35432 -c "DROP DATABASE IF EXISTS db_script;"
psql -U user -h 192.168.10.23 -p 35432 -c "CREATE DATABASE db_script;"
psql -U user -h 192.168.10.23 -p 35432 -d db_script -c " CREATE EXTENSION postgis;"

echo "montons-y nos données"

ogr2ogr -f "PostgreSQL" PG:"dbname=db_script user=user host=192.168.10.23" -nln courbes_niveau -a_srs EPSG:2154 courbes_niveau_09.shp

echo "les communes directement dans la base, sans bouger"

ogr2ogr -f "PostgreSQL" PG:"dbname=db_script user=user host=192.168.10.23" -nln communes_09 -s_srs EPSG:4326 -t_srs EPSG:2154 WFS:https://data.geopf.fr/wfs/wfs?SERVICE=WFS BDTOPO_V3:commune -where "code_insee like '09%'"

echo "création d'une vue des courbes de niveau des communes qui commencent pas F"

psql -U user -h 192.168.10.23 -p 35432 -d db_script -c "CREATE VIEW courbes_com_f AS SELECT a.*, b*, ST_intersection(a.geom,b.geom) from courbes_niveau a JOIN communes b ON ST_intersects(a.geom,b.geom);"

echo "et voilà c'est déjà fini"