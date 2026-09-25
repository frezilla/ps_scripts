# _alwaysHere_ #

## Objectif ##
Ce script simule une activité utilisateur.

Deux évènements sont simulés :
- Mouvement (imperceptible) de la souris
- Pression sur une touche clavier (Verrouillage Numérique)

Ces deux évènements sont exécutés à une fréquence définie pendant une période définie par l'utilisateur.
L'utilisateur peut stopper le script à tout moment en appuyant sur les touches Ctrl+C.

## Lancement ##
Ce script accepte deux paramètres :
- DurationMinutes : la durée d'exécution du script
- IntervalSeconds : la temps d'attente entre deux évènements

Les valeurs sont exprimées en secondes.

Exemple de lancement dans une console PowerShell :

```
.\alwaysHere.ps1 --DurationMinutes 60 --IntervalSeconds 10
```

ou

```
.\alwaysHere.ps1
```
