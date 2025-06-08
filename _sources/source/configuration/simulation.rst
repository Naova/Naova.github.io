.. _simulation:

Déployer en Simulation
=======================

Étapes de déploiement
---------------------

1. **Compiler les modifications**

   Pour compiler les changements apportés au code, exécutez :

   .. code-block:: console

      ./Remake

2. **Lancer la simulation**

   - Démarrez la simulation en lançant :

     .. code-block:: console

        ./SimRobot

   - Dans le menu *File*, sélectionnez **BHFast.ros2**.

     .. figure:: ../_static/configuration/file_selection.jpg
        :width: 70%
        :alt: Capture d'écran de la sélection du fichier bhfast.ros2

   - Dans la console de l'interface, tapez la commande suivante pour démarrer une partie avec un robot :

     .. code-block:: console

        gc playing

   - La commande déclenche l'initialisation du robot, comme illustré ci-dessous :

     .. figure:: ../_static/configuration/gc_playing.jpg
        :width: 90%
        :alt: Interface après l'exécution de la commande gc playing

.. note::

    Ajoutez ici d'autres images ou exemples de commandes si nécessaire.
