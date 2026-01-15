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

   .. tab-item:: :icon:Linux
      :sync: linux

      .. note::

         Nous l'avons testé seulement sur Ubuntu 22.04LTS.

      .. code:: console

         rm -rf docs/_build && ./naova.sh

   .. tab-item:: :icon:Windows
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

Le langage **reStructuredText (RST)** est utilisé pour la documentation technique et est largement adopté par **Sphinx**.  
Voici les principales fonctionnalités utiles pour rédiger efficacement vos documents.


Insertion de liens
^^^^^^^^^^^^^^^^^^

Il existe plusieurs façons d'ajouter des liens en RST :

1. **Lien simple intégré dans le texte** ::

    Voir la documentation officielle `Sphinx <https://www.sphinx-doc.org/>`_.

2. **Lien nommé (réutilisable dans plusieurs endroits du document)** ::

    .. _sphinx-docs: https://www.sphinx-doc.org/

    Consultez la `documentation Sphinx <sphinx-docs_>`_.


Mise en forme du texte
^^^^^^^^^^^^^^^^^^^^^^

- **Gras** : ``**Texte en gras**`` → **Texte en gras**  
- *Italique* : ``*Texte en italique*`` → *Texte en italique*  
- ``Texte en monospace`` : ```code``` → `code`
- Liste à puces ::

   - Élément 1
   - Élément 2

- Liste numérotée ::

   1. Premier élément
   2. Deuxième élément


Créer des sous-sections
^^^^^^^^^^^^^^^^^^^^^^^

RST permet d'organiser un document en sections et sous-sections en utilisant différentes ponctuations ::

   Titre principal
   ===============

   Section
   -------

   Sous-section
   ^^^^^^^^^^^^

   Sous-sous-section
   """""""""""""""""


Insertion d'images
^^^^^^^^^^^^^^^^^^

Pour ajouter une image ::

   .. image:: source/_static/project_name/nao_robot.png
      :alt: Nao Robot
      :width: 300px
      :align: center

    Cela affichera `source/_static/project_name/nao_robot.png` avec une largeur de **300px** et alignée au centre.


Insertion de vidéos
^^^^^^^^^^^^^^^^^^^

Les vidéos peuvent être intégrées sous forme de liens ou via HTML brut si nécessaire :

1. **Lien vers une vidéo YouTube** ::
    
    Voir la démonstration sur YouTube : `Vidéo RoboCup <https://www.youtube.com/watch?v=xvFZjo5PgG0>`_.


2. **HTML pour intégrer directement une vidéo** (nécessite `html` dans Sphinx) ::

    .. raw:: html
        <iframe width="560" height="315" src="https://www.youtube.com/embed/xvFZjo5PgG0" frameborder="0" allowfullscreen></iframe>


Références à d'autres pages
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il est possible de créer des liens vers d'autres sections ou pages de la documentation.

1. **Lien vers une section de la même page** ::

    Voir la section :ref:`Insertion d'images <insertion-images>`.

   Pour que cela fonctionne, la section doit être marquée avec une **étiquette** ::
    
    .. _insertion-images:

       Insertion d'images
       ------------------

2. **Lien vers une autre page de la documentation** ::

    Voir aussi :ref:`autre_page`

   où `autre_page.rst` est un fichier dans le même projet.

3. **Lien vers une référence bibliographique** (avec `sphinxcontrib-bibtex`) ::

    Voir l'article :cite:`kali2021walking`

   La citation doit être définie dans un fichier `.bib` inclus dans la documentation.
