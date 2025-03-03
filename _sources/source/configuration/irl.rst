.. _irl:

Déployer sur un Robot Réel
==========================

Étapes de déploiement
---------------------

1. **Préparer le robot**

   - Allumez le robot. (Ajouter des instructions/photos de comment faire)
   - Connectez un câble Ethernet entre le robot et l'ordinateur.

2. **Lancer le déploiement sur le robot**

   - Compilez le code pour intégrer d'éventuels changements :

     .. code-block:: console

        ./Remake

   - Lancez le déploiement en exécutant :

     .. code-block:: console

        ./bush

3. **Compiler via l'interface**

   - Dans l'interface, cochez le *Player* voulu et cliquez sur *deploy* pour lancer la compilation.

   - L'interface de déploiement s'affiche comme indiqué ci-dessous :

     .. figure:: ../_static/configuration/interface_deploy.jpg
        :width: 80%
        :alt: Interface de déploiement avec l'option de "Player" et le bouton "Deploy"
