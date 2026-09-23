# Documentation des projets de Naova

Bienvenue dans la documentation des projets réalisés par les membres du club **Naova**. Ce site centralise toutes les informations relatives aux projets en cours et terminés, afin de faciliter leur gestion et la collaboration entre les membres.

## Objectif

Cette documentation a pour objectif de répertorier les différents projets développés par Naova, permettant ainsi de s'y retrouver facilement et d'assurer une meilleure transmission d'informations pour les nouveaux membres du club.

## Comment contribuer

Pour savoir comment contribuer à cette documentation ou ajouter un projet, veuillez consulter la page dédiée à la contribution :  
[Comment contribuer](https://naova.github.io/source/refs/contributing.html).

## Build local de la documentation

Vous pouvez générer la documentation en local depuis la racine du dépôt avec les scripts fournis.

### Ubuntu

Prérequis :

- `python3` installé et accessible dans le `PATH`
- `pip` disponible

Commande :

```bash
./naova.sh
```

Le script :

- installe les dépendances Python depuis `docs/requirements.txt`
- génère la documentation Sphinx dans `docs/_build/current`
- ouvre automatiquement la page d'accueil dans le navigateur

Si le navigateur ne s'ouvre pas automatiquement :

```bash
xdg-open docs/_build/current/index.html
```

### Windows

Prérequis :

- Python installé et accessible dans le `PATH`
- `pip` disponible

Commande (depuis `cmd`) :

```bat
naova.bat
```

Le script :

- supprime l'ancien build dans `docs\_build`
- installe les dépendances si nécessaire depuis `docs\requirements.txt`
- génère la documentation Sphinx dans `docs\_build\html`
- ouvre automatiquement `index.html`

## Projets

Voici quelques projets actuellement documentés :

- **Contrôleur de marche**
- **Détection de balle**
- **Détection de ligne**

Chaque projet dispose de sa propre documentation.

## Site Web

La documentation est publiée sur GitHub Pages à l'adresse suivante :  
[https://naova.github.io](https://naova.github.io)

Pour plus d'informations sur le club Naova, visitez notre site officiel :  
[Naova Website](https://clubnaova.ca/)

## Licence

Cette documentation est sous la licence BSD-3-Clause. Pour plus de détails, veuillez consulter la [licence](LICENSE).

## Remerciements

Merci aux membres de Naova pour leurs contributions et leur engagement dans ce projet de documentation. Pour voir la liste complète des développeurs des projets de Naova, consultez le fichier [CONTRIBUTORS.md](https://github.com/Naova/Naova.github.io/blob/main/CONTRIBUTORS.md).
