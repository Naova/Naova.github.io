===========================================
Détecteur de lignes pour Robot NAO
===========================================

Rapport de projet présenté à l’École de Technologie Supérieure  
Université du Québec

**Auteurs :** St-Pierre, Olivier & Bisson, Marc-Olivier  
**Date :** Montréal, le 14 décembre 2024

.. contents:: Table des matières
   :local:
   :depth: 2

Présentation du problème
=========================

Avant 2021, les lignes étaient réalisées avec du ruban adhésif, offrant un fort contraste.  
Depuis, les lignes peinturées et les conditions d’éclairage moins contraignantes rendent  
la détection plus difficile pour le robot. Le détecteur actuel nécessite une calibration  
longue et reste sensible aux variations de luminosité et aux dégradations du terrain.

.. image:: ../_static/projects/detection_de_ligne/lignesRuban.jpg
   :alt: Lignes faites avec du ruban
   :width: 300px
   :align: center

.. image:: ../_static/projects/detection_de_ligne/lignesPeinturees.png
   :alt: Lignes peinturées
   :width: 300px
   :align: center


Analyse
=======

Plateforme NAO
--------------

Le robot NAO, équipé d’un processeur Atom E3845 (4 cœurs à 1,91 GHz), 4 Go de RAM et  
de deux caméras (résolutions et fréquences variables), impose des contraintes en temps réel  
et en capacité de calcul. La caméra supérieure est utilisée à une résolution de 640×480 px,  
tandis que la caméra inférieure fonctionne à 320×240 px.

Solution de B-Human
-------------------

La solution initiale (B-Human, 2021) consiste à :
- Générer une grille de points couvrant la zone du terrain.
- Scanner ces points verticalement et horizontalement afin de classifier les zones en « ligne blanche » ou « terrain vert ».
- Utiliser une régression linéaire pour tracer les lignes et appliquer un test de la couleur blanche pour valider les segments.

Cette approche fonctionne bien avec des rubans adhésifs mais montre ses limites avec  
des lignes peinturées et sous des conditions lumineuses variées.

Inspiration
-----------

Le projet s’inspire d’un travail réalisé dans le cadre du cours MTI805 par Antoine De Roover  
et son collègue Nicolas, qui avaient développé un détecteur de ligne en Python. Leur solution  
a servi de point de départ pour améliorer la robustesse et la performance du détecteur.


Métriques utilisées et jeux de données
========================================

Trois métriques principales ont été retenues pour évaluer le détecteur :

- **Rappel :** Mesure la proportion des lignes présentes qui ont été correctement détectées.
- **Précision :** Évalue la capacité du détecteur à limiter les faux positifs.
- **F-score :** Combine rappel et précision pour fournir une évaluation globale.

Un jeu de données annoté, composé d’une trentaine d’images (réalisé avec le logiciel LabelMe),  
permet de comparer les lignes détectées aux annotations de référence.


Conception
==========

Plusieurs algorithmes d’OpenCV ont été intégrés afin d’obtenir une détection robuste :

Resize
------

Le redimensionnement de l’image permet de réduire la charge de calcul tout en conservant  
une résolution suffisante pour détecter les lignes à distance.

Flou gaussien
-------------

Un flou gaussien est appliqué pour atténuer les détails non pertinents et réduire le bruit  
avant les étapes ultérieures de traitement.

Seuil
-----

La conversion en image binaire se fait en deux temps :
 
- **Seuil absolu :** On conserve les pixels avec des valeurs entre 180 et 255.
- **Seuil adaptatif :** Le seuil est déterminé localement, ce qui s’avère particulièrement utile  
  en présence d’éclairages inégaux.

Squelettisation
---------------

La squelettisation permet d’extraire la ligne médiane (squelette) des formes obtenues par le  
seuil, facilitant ainsi la détection de la ligne centrale du trait.

Érosion et dilatation
---------------------

Ces opérations morphologiques permettent de réduire (érosion) puis d’agrandir (dilatation)  
les zones blanches, renforçant ainsi le résultat de la squelettisation.

Soustraction et OU binaire
--------------------------

Utilisées pour extraire les différences entre l’image érodée et dilatée, ces opérations  
aident à conserver uniquement l’information pertinente.

Filtre des blobs
----------------

Le filtrage des blobs permet d’éliminer les petits amas de pixels (bruit) et de conserver  
les segments de lignes de plus grande surface.

Hough
-----

La transformée de Hough est employée pour détecter et extraire les segments de lignes à partir  
de l’image traitée en identifiant les votes dans un espace paramétrique défini par rho et thêta.

Détecteur de bord de terrain et Canny
-------------------------------------

L’algorithme de détection de bord de terrain (issu de B-Human) permet d’exclure les zones  
hors du terrain. Initialement, Canny était utilisé pour la détection des contours, mais il a  
été remplacé par la squelettisation afin d’éviter la détection double des bords d’une ligne.


Implémentation
==============

Prototypage
-----------

La première version du détecteur s’inspirait fortement de la solution d’Antoine et Nicolas,  
mais rencontrait des problèmes de détection multiple et de segments partiels.

Intégration dans le code du NAO
-------------------------------

Pour intégrer la nouvelle solution :
- La librairie OpenCV a été intégrée (avec cross-compilation pour le NAO).
- Le code Python du prototype a été traduit en C++ et intégré dans le module *LinePerceptor*.
- Un redimensionnement de l’image a permis d’améliorer les performances, malgré une légère augmentation du temps d’exécution par rapport à la solution B-Human.

Les paramètres finaux (différents pour la caméra du haut et du bas) ont permis d’obtenir des  
temps d’exécution de l’ordre de 20 ms (caméra du haut) et 9,4 ms (caméra du bas).


Limites de la solution
=======================

Quelques limitations subsistent :
- La détection des cercles n’est pas encore intégrée.
- Des faux positifs peuvent apparaître sur les robots, les humains ou le filet du but.
- Le processus de détection reste gourmand en ressources, provoquant une surchauffe du robot après une utilisation prolongée.
- La combinaison des lignes détectées (fusion des segments) doit être améliorée pour éviter les duplications.

Conclusion
==========

La nouvelle solution offre une meilleure portée de détection et une robustesse accrue face aux  
nouvelles conditions de jeu. Toutefois, des améliorations restent à apporter notamment pour  
réduire les faux positifs et optimiser la charge de calcul. Des développements futurs viseront  
à intégrer la détection des cercles et à optimiser davantage l’algorithme afin de le rendre  
plus adapté à une utilisation continue sur le NAO.

Bibliographie
=============

- *A Brief History of RoboCup.* Retrieved from  
  https://robocup.org/a_brief_history_of_robocup
- *Canny edge detector.* In Wikipedia. Retrieved from  
  https://en.wikipedia.org/w/index.php?title=Canny_edge_detector
- *Gaussian blur.* In Wikipedia. Retrieved from  
  https://en.wikipedia.org/w/index.php?title=Gaussian_blur
- Hasselbring, A. & Baude, A. (2022). Soccer Field Boundary Detection Using Convolutional Neural Networks.  
- *Hough transform.* In Wikipedia. Retrieved from  
  https://en.wikipedia.org/w/index.php?title=Hough_transform
- *Localization Features - B-Human.* Retrieved from  
  https://docs.b-human.de/master/perception/localization-features/
- *NAO - Video camera — Aldebaran documentation.* Retrieved from  
  http://doc.aldebaran.com/2-1/family/robots/video_robot.html
- *OpenCV Tutorials* (divers articles sur Canny, Thresholding, Morphological Operations, etc.)

