## Exercice - Création d'un script bash

Créer un script simple qui s'éxécute qui permet de réaliser certaines actions en utilisant nos librairie bas niveau.

Si vous souhaitez, vous pouvez améliorer ce script pour automatiser un processus qui mette à jour des données.

Les utilitaires à utiliser : wget, zip, ogr2ogr, gdal ..., psql

Il s'agit donc : 

- récupérer des données ouvertes sur un portail open data, le mnt 25m d'un département de votre choix. 
La couche des départements Admin  Express.

- reprojetter si nécessaire

- découper le mnt du département choisi

- créer une base de données sur le serveur de bdd

- transformer ce mnt en courbe de niveau et enregistrer la nouvelle couche en tant que couche postgis

- Injecter les communes du département qui commençent par la lettres "f"

- créer une vue des courbes de niveau de ces communes 



