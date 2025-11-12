# Wiki du Projet NaovaK1

Bienvenue sur la documentation du projet NaovaK1 !

## Présentation

Ceci est le wiki officiel de documentation pour le projet NaovaK1, hébergé sur GitHub Pages à l'adresse [https://naovak1.github.io](https://naovak1.github.io).

## Table des Matières

- [À Propos du Projet](#à-propos-du-projet)
- [Démarrage](#démarrage)
- [Structure du Dépôt](#structure-du-dépôt)
- [Contribuer](#contribuer)
- [Licence](#licence)
- [Contact](#contact)

## À Propos du Projet

NaovaK1.github.io est un dépôt GitHub Pages pour l'hébergement de contenu et de documentation du projet.

### Fonctionnalités Principales

- Hébergement de site web statique via GitHub Pages
- Génération de site basée sur Jekyll
- Open source sous licence MIT

## Démarrage

### Prérequis

Pour travailler avec ce dépôt localement, vous aurez besoin de :

- Git installé sur votre machine
- Un éditeur de texte ou IDE
- (Optionnel) Jekyll pour le développement local

### Installation

1. Cloner le dépôt :
   ```bash
   git clone https://github.com/Naova/NaovaK1.github.io.git
   cd NaovaK1.github.io
   ```

2. Apporter vos modifications au contenu

3. Valider et pousser vos modifications :
   ```bash
   git add .
   git commit -m "Votre message de commit"
   git push origin main
   ```

### Développement Local

Si vous souhaitez tester le site localement avec Jekyll :

```bash
# Installer Jekyll et les dépendances
gem install bundler jekyll

# Servir le site localement
jekyll serve

# Visiter http://localhost:4000 dans votre navigateur
```

## Structure du Dépôt

```
NaovaK1.github.io/
├── .git/                  # Données du dépôt Git
├── .gitignore            # Modèles d'exclusion Git
├── LICENSE               # Fichier de licence MIT
├── README.md             # README du dépôt
└── wiki/                 # Documentation du projet
    └── Home.md           # Page d'accueil du wiki
```

## Contribuer

Nous accueillons les contributions à ce projet ! Voici comment vous pouvez aider :

### Comment Contribuer

1. **Forker le dépôt** - Créer votre propre copie du projet
2. **Créer une branche de fonctionnalité** - `git checkout -b feature/nom-de-votre-fonctionnalite`
3. **Apporter vos modifications** - Ajouter vos contributions
4. **Valider vos modifications** - `git commit -m "Ajouter une fonctionnalité"`
5. **Pousser vers la branche** - `git push origin feature/nom-de-votre-fonctionnalite`
6. **Ouvrir une Pull Request** - Soumettre vos modifications pour révision

### Directives

- Garder les commits atomiques et bien décrits
- Suivre le style de code/contenu existant
- Tester vos modifications avant de les soumettre
- Mettre à jour la documentation si nécessaire

## Licence

Ce projet est sous licence MIT - voir le fichier [LICENSE](../LICENSE) pour plus de détails.

## Contact

- **Dépôt** : [https://github.com/Naova/NaovaK1.github.io](https://github.com/Naova/NaovaK1.github.io)
- **GitHub Pages** : [https://naovak1.github.io](https://naovak1.github.io)

---

*Dernière mise à jour : Novembre 2025*
