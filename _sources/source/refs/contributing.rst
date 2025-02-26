.. _contributing:

Comment contribuer
==================

Une fois que vous avez terminé un projet chez Naova, il vous sera demandé de le documenter sur ce site. 
Cette page vous guidera dans le processus.

Étapes à suivre
---------------

1. Exécutez la commande suivante pour cloner le dépôt :

.. code-block:: console
    
    git clone https://github.com/Naova/Naova.github.io.git

2. Ensuite, entrez dans le répertoire du projet :

.. code-block:: console

    cd Naova.github.io

3. Pour mettre votre dépôt local à jour avec le dernier état de la branche principale, exécutez :

.. code-block:: console

    git fetch origin
    git checkout main
    git reset --hard origin/main

4. Créez une nouvelle branche avec la commande suivante :

.. code-block:: console
    
    git checkout -b nom_de_votre_projet

5. Créez un fichier nommé `nom_de_votre_projet.rst` dans le dossier `docs/source/projects/`.

6. Au début du fichier, ajoutez les lignes suivantes :

.. code-block:: RST
    
    .. _nom_de_votre_projet:

    Titre
    =====

Veillez à placer un underscore avant le nom de votre projet et à vous assurer que les signes égal sous le titre sont de la même longueur.

7.  Ajoutez votre projet à `index.rst` dans la section "Projets".

8.  Documentez votre projet dans le fichier `.rst`. Une fois que c'est fait pour construire et ouvrir la documentation localement entrez : 

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. note::

         Nous l'avons testé seulement sur Ubuntu 22.04LTS.

      .. code:: console

         rm -rf docs/_build && ./naova.sh

   .. tab-item:: :icon:`fa-brands fa-windows` Windows
      :sync: windows

      .. note::

         WIP

      .. code:: console

         naova.bat

9.   Assurez-vous que votre utilisateur Git local est à jour, ou exécutez :

.. code-block:: console
    
    git config --global user.email "email@example.com"
    git config --global user.name "username"

C'est l'utilisateur et l'email qui apparaîtront dans l'historique GitHub.

10.  Exécutez la commande suivante pour sélectionner les modifications que vous souhaitez ajouter :

.. code-block:: console
    
    git add -p

11. Validez vos modifications avec la commande suivante :

.. code-block:: console
    
    git commit -m "Description du changement"

12. Forkez `Naova/Naova.github.io <https://github.com/Naova/Naova.github.io#fork-destination-box>`_.

13. Ajoutez le dépôt forké avec la commande suivante :

.. code-block:: console
    
    git remote add fork https://github.com/username/Naova.github.io.git

**Remplacez** `username` par votre nom d'utilisateur GitHub.

14.  Récupérez les mises à jour de votre fork avec la commande suivante :

.. code-block:: console
    
    git fetch fork

15. Poussez votre branche vers votre fork avec la commande suivante :

.. code-block:: console
    
    git push fork

16. Rendez-vous sur votre fork sur GitHub à l'adresse suivante : `https://github.com/username/Naova.github.io`.

17. Cliquez sur le bouton `New pull request`.

18. Dans la liste déroulante `base`, sélectionnez `main`, car vous souhaitez soumettre une PR vers cette branche.

19. Dans la liste déroulante `compare`, sélectionnez votre branche (`nom_de_votre_contribution`).

20. Passez en revue vos modifications et cliquez sur `Create pull request`.

21. Attendez que tous les tests automatisés soient passés.

22. La PR sera approuvée ou rejetée après examen par l'équipe.

Nouvelles modifications 
-----------------------

Pour continuer avec une nouvelle modification, revenez à l'étape 3.  
Pour revenir à votre PR et apporter de nouvelles modifications :

1. Exécutez la commande suivante pour mettre de côté les modifications en cours :

.. code-block:: console
    
    git stash

2. Exécutez la commande suivante pour revenir à votre branche de contribution :

.. code-block:: console
    
    git checkout nom_de_votre_contribution

3.  Répétez les étapes 10 et 11.

4.  Poussez vos modifications à nouveau avec la commande suivante :

.. code-block:: console
    
    git push fork

La pull request sera automatiquement mise à jour.

Bon à savoir sur l'écriture en RST
----------------------------------

(à compléter)