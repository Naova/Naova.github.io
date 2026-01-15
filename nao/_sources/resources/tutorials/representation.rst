.. _representation:

Créer une nouvelle représentation
=================================

Dans ce tutoriel, nous allons voir comment créer une représentation en utilisant le cas précis de la détection d’un objet rouge via la caméra.

Le code
-------

.. dropdown:: Code pour *ColorDetect.h*  
    :icon: code

    .. code-block:: cpp
        :linenos:
        :emphasize-lines: 1-7, 9, 11-12, 13-21

        /**
        * @file ColorDetect.h
        * 
        * This file declares a struct represents the requested information from the red color detection.
        * 
        * @author Louis Le Lay
        */

        #pragma once

        #include "Tools/Math/Angle.h"
        #include "Tools/Streams/AutoStreamable.h"

        /**
        * @struct ColorDetect
        * A struct that represents the requested information from the color detection.
        */
        STREAMABLE(ColorDetect,
        {,
        (bool)(true) isThereRedColor, /**< Give the information if there is a red color or not */
        });

Explications
------------

Cette fois, nous allons créer le fichier *ColorDetect.h* dans le répertoire ``Src/Representations/Perception/ColorDetects/``.

Tout d'abord, nous commençons par ajouter un commentaire en tête du fichier, comme d'habitude :

.. code-block:: cpp

    /**
    * @file ColorDetect.h
    * 
    * This file declares a struct represents the requested information from the red color detection.
    * 
    * @author Louis Le Lay
    */

Ensuite, nous incluons les outils nécessaires :

.. code-block:: cpp

    #pragma once

    #include "Tools/Math/Angle.h"
    #include "Tools/Streams/AutoStreamable.h"

Enfin, nous définissons la structure de notre représentation. Dans notre cas, la seule information qui nous intéresse est celle évoquée dans le tutoriel :ref:`module`, à savoir *isThereRedColor*, un booléen.

.. code-block:: cpp

    /**
    * @struct ColorDetect
    * A struct that represents the requested information from the color detection.
    */
    STREAMABLE(ColorDetect,
    {,
    (bool)(true) isThereRedColor, /**< Give the information if there is a red color or not */
    });

Vous venez ainsi de créer une représentation. Passez maintenant au tutoriel suivant pour l'intégrer dans le fichier de configuration.