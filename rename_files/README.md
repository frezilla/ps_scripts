# _renameFiles_ #

## Objectif ##
Ce script renomme en masse les fichiers d'un répertoire en se basant sur une table de mapping.

La table de mapping est stockée dans un fichier CSV dont le séparateur est le point virgule (;).

La structure du fichier est :
- Une ligne d'entête : Source;Destination
- N lignes de données : <nom du fichier source>;<nom du fichier destination>

Des avertissements sont affichés dans la console de l'utilisateur si :
- Le fichier source est introuvable
- Le fichier destination existe déjà

Un message d'erreur est affiché si le renommage est techniquement impossible.

## Lancement ##
Ce script accepte trois paramètres :
- Directory (obligatoire) : le chemin vers le répertoire qui contient les fichiers à renommer
- MappingFile (obligatoire) : le chemin vers le fichier csv
- Simulation (facultatif) : simule le renommage des fichiers

Exemple de lancement dans une console PowerShell :

```
.\renameFiles.ps1 -Directory "c:\temp" -MappingFile "c:\mapping.csv"
```
