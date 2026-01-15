.. _core-concepts:

Concepts de base
================

Bindings et Threads
-------------------

Le logiciel de Naova (dérivé de celui de B-Human) fonctionne sous forme d'un exécutable unique avec plusieurs fichiers de configuration. 
Lors du démarrage, il vérifie l'identité du robot avant de lancer le programme principal. 
Ce dernier communique avec LoLA, l'interface du NAO, en utilisant une communication bloquante pour assurer une synchronisation efficace.

Le système repose sur plusieurs threads parallèles, chacun ayant une fonction spécifique. 
Parmi eux, les threads de perception traitent les images des caméras en parallèle, 
tandis que d'autres gèrent la cognition et le mouvement. 
Un dernier thread s'occupe de la communication avec un PC distant pour le débogage.


Modules et Représentations
--------------------------

Le logiciel est conçu sous forme de modules interconnectés, 
chacun ayant des entrées et sorties appelées "représentations". 
Une structure de "blackboard" est utilisée pour stocker ces représentations, 
et les modules sont automatiquement ordonnés en fonction de leurs dépendances.

Chaque module est défini par son interface, 
son implémentation et une déclaration permettant son instanciation. 
Les modules peuvent être paramétrés dynamiquement via des fichiers de configuration ou des commandes interactives.

Serialization
-------------

La sérialisation permet de convertir les données en une suite d'octets pour le stockage ou la transmission. 
Le système utilise une approche similaire à la bibliothèque iostreams de C++, 
avec des opérateurs << et >> pour la lecture et l'écriture. 
Une hiérarchie de flux est utilisée pour gérer différents formats, 
notamment binaire et texte. Des classes dérivées permettent d'automatiser la sérialisation de structures complexes.


Communication
-------------

La communication au sein du système se fait à trois niveaux : 
entre threads, avec un PC pour le débogage, et entre robots d'une équipe. 
La communication inter-thread est triple-bufferisée pour éviter les blocages. 
Le débogage repose sur des messages échangés via une file d'attente. 
Enfin, la communication en équipe se fait par UDP, 
permettant à chaque robot d'envoyer et recevoir des informations essentielles au jeu en temps réel.


Debugging
---------

Le système propose plusieurs outils de débogage, notamment des requêtes de débogage activables dynamiquement, 
des images de débogage permettant d'afficher des données de traitement visuel, et des dessins vectoriels superposés à l'affichage. 
Des chronomètres intégrés permettent de mesurer les temps d'exécution des différentes parties du code.


Logging
-------

Les journaux d'exécution permettent d'enregistrer les données collectées et traitées par le robot pour une analyse ultérieure. 
Deux modes sont disponibles : 
l'enregistrement en ligne directement sur le robot et l'enregistrement à distance sur un PC via une connexion de débogage. 
Les fichiers de logs peuvent être rejoués dans le simulateur pour tester et améliorer les modules sans avoir besoin d'un robot physique.

