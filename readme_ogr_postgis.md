GDAL / OGR et PostGIS
---------

EN mode ETL, la librairie comme outil pour alimenter sa base de données préférée !


> Injestion d'un shape dans une table ..
```
ogr2ogr -f "PostgreSQL" PG:"dbname=ma_base user=mon_user password=mon_mdp host=localhost port=5432" \
    "mon_fichier.shp" \
    -nln ma_table \
    -lco GEOMETRY_NAME=geom \
    -lco FID=gid \
    -lco SPATIAL_INDEX=GIST \
    -overwrite
```

> Injestion d'un shape dans une table - mise à jour
```bash
ogr2ogr -f "PostgreSQL" PG:"dbname=ma_base user=mon_user password=mon_mdp host=localhost port=5432" \
    "mon_fichier.geojson" \
    -nln ma_table \
    -append

```

> Reprojection de la source vers la destination
```bash
ogr2ogr -f "PostgreSQL" PG:"dbname=ma_base user=mon_user password=mon_mdp host=localhost port=5432" \
    "mon_fichier.shp" \
    -nln ma_table_l93 \
	-s_srs EPSG:4326
    -t_srs EPSG:2154 \
    -lco GEOMETRY_NAME=geom \
    -lco SPATIAL_INDEX=GIST \
    -overwrite
```

> Mise à jour des données en fonction de l'identifiant (préparer les données en amont)
```bash
ogr2ogr -f "PostgreSQL" PG:"dbname=ma_base user=mon_user password=mon_mdp host=localhost port=5432" \
    "mon_fichier.shp" \
    -nln ma_table \
    -update \
    -fid id
```

> Rappel psql (cleint mode CLI)

```bash
psql -h localhost -U mon_user -d ma_base -c "\copy ma_table_csv FROM 'mon_fichier.csv' DELIMITER ',' CSV HEADER;"
```


