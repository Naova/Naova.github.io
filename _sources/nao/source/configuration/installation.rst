.. _installation:

Installation
============

.. note::
   **Pré-requis :**
   
   - Faire partie de l'organisation GitHub "Naova"
   - Utiliser Ubuntu (>=20)

Étapes d'installation
---------------------

1. Installer les dépendances :

   .. code-block:: console

      sudo apt install git

2. Générer une clé SSH et l'ajouter à GitHub :

   - Générer la clé SSH en exécutant :
     
     .. code-block:: console

        ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
   
   - Suivre les instructions affichées pour compléter la génération.
   - Copier la clé publique en utilisant la commande suivante :

     .. code-block:: console

        cat ~/.ssh/id_rsa.pub

     (Vous pouvez copier le contenu affiché dans votre terminal.)
   
   - Se connecter à votre compte GitHub et accéder à la section **SSH and GPG keys** pour ajouter votre nouvelle clé.

3. Cloner le dépôt Git :

   .. code-block:: console

      git clone https://github.com/Naova/Scripts.git

4. Lancer le script d'installation :

   - Se déplacer dans le dossier cloné :

     .. code-block:: console

        cd Scripts

   - Donner les droits d'exécution au script :

     .. code-block:: console

        chmod 700 installation.sh

   - Exécuter le script :

     .. code-block:: console

        ./installation.sh

5. Tester l'installation :

   - Le script installe le code dans le répertoire ``~/naova``.
   - Se déplacer dans le dossier :

     .. code-block:: console

        cd ~/naova

   - Lancer SimRobot :

     .. code-block:: console

        ./SimRobot
