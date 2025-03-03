.. _module:

Créer un nouveau module
=======================

Dans ce tutoriel, nous allons voir comment créer un module en utilisant le cas précis de la détection d’un objet rouge via la caméra.

Le code
-------

.. dropdown:: Code pour *ColorDetector.h*  
   :icon: code

   .. code-block:: cpp
      :linenos:
      :emphasize-lines: 1-7, 9-11, 13-15, 17-21, 24-29, 31-44

      /**
      * @file ColorDetector.h
      *
      * This file declares a module that detects red color in images with opencv.
      *
      * @author Louis Le Lay
      */

      #include "Representations/Infrastructure/CameraInfo.h"
      #include "Representations/Infrastructure/CameraImage.h"
      #include "Representations/Perception/ColorDetects/ColorDetect.h"

      #include <opencv2/dnn.hpp>
      #include <opencv2/imgproc.hpp>
      #include <opencv2/highgui.hpp>

      #include <iostream>
      #include <random>
      #include <set>
      #include <cmath>
      #include <algorithm>  // for std::min, std::max


      MODULE (ColorDetector,
      {,
          REQUIRES(CameraInfo),
          REQUIRES(CameraImage),
          PROVIDES(ColorDetect),
      });

      class ColorDetector : public ColorDetectorBase
      {
      private:
          inline unsigned char clamp(int value);
          BGRImage getBGRImage();
          cv::Mat BGRImageToMat(const BGRImage &img);
          bool getRedColor(const cv::Mat &image);

      /**
       * This method is called when the representation provided needs to be updated.
       * @param ColorDetect The representation updated.
       */
          void update(ColorDetect& theColorDetect) override;
      };

.. dropdown:: Code pour *ColorDetector.cpp*  
   :icon: code

   .. code-block:: cpp
      :linenos:
      :emphasize-lines: 1-7, 9-13, 94-107

      /**
      * @file ColorDetector.cpp
      *
      * This file declares a module that detects red color in images with opencv.
      *
      * @author Louis Le Lay
      */

      #include "ColorDetector.h"

      MAKE_MODULE(ColorDetector, perception);

      #include "Platform/File.h"


      /*----- methodes -----*/


      // Helper function to clamp values between 0 and 255.
      inline unsigned char ColorDetector::clamp(int value) {
          return static_cast<unsigned char>(std::min(255, std::max(0, value)));
      }

      BGRImage ColorDetector::getBGRImage() const {
          // Create a BGR image with doubled width (each YUYV pixel produces two BGR pixels)
          BGRImage ret(width * 2, height);
          unsigned char* dest = ret[0];
          const PixelTypes::YUYVPixel* src = (*this)[0];

          for (unsigned y = 0; y < height; y++) {
              for (unsigned x = 0; x < width; x++) {
                  // Each YUYVPixel contains two Y values and shared U and V.
                  int y0 = src->y0;
                  int y1 = src->y1;
                  int u = src->u;
                  int v = src->v;

                  // Conversion formulas from YUV to RGB:
                  // R = Y + 1.403 * (V - 128)
                  // G = Y - 0.344 * (U - 128) - 0.714 * (V - 128)
                  // B = Y + 1.770 * (U - 128)
                  // We output in BGR order.

                  // First pixel (using y0)
                  int r = static_cast<int>(y0 + 1.403 * (v - 128));
                  int g = static_cast<int>(y0 - 0.344 * (u - 128) - 0.714 * (v - 128));
                  int b = static_cast<int>(y0 + 1.770 * (u - 128));
                  dest[0] = clamp(b);
                  dest[1] = clamp(g);
                  dest[2] = clamp(r);
                  dest += 3;

                  // Second pixel (using y1)
                  r = static_cast<int>(y1 + 1.403 * (v - 128));
                  g = static_cast<int>(y1 - 0.344 * (u - 128) - 0.714 * (v - 128));
                  b = static_cast<int>(y1 + 1.770 * (u - 128));
                  dest[0] = clamp(b);
                  dest[1] = clamp(g);
                  dest[2] = clamp(r);
                  dest += 3;

                  // Move to next YUYV pixel
                  src++;
              }
          }
          return ret;
      }

      cv::Mat ColorDetector::BGRImageToMat(const BGRImage &img) {
          // Wrap the image data into a cv::Mat without copying:
          // Note: Make sure the BGRImage's lifetime covers the cv::Mat usage.
          return cv::Mat(img.height, img.width, CV_8UC3, (void*)img.data());
      }

      bool ColorDetector::getRedColor(const cv::Mat &image) {
          if (image.empty() || image.channels() != 3) {
              return false;
          }

          cv::Mat hsv;
          cv::cvtColor(image, hsv, cv::COLOR_BGR2HSV);

          cv::Mat mask1, mask2;
          cv::inRange(hsv, cv::Scalar(0, 100, 100), cv::Scalar(10, 255, 255), mask1);
          cv::inRange(hsv, cv::Scalar(160, 100, 100), cv::Scalar(180, 255, 255), mask2);

          cv::Mat mask = mask1 | mask2;
          return cv::countNonZero(mask) > 0;
      }


      /*----- méthode particulière au module -----*/

      void ColorDetector::update(ColorDetect& theColorDetect)
      {
          BGRImage bgrImage;
          bgrImage = theColorDetect.getBGRImage();

          cv::Mat input;
          input = BGRImageToMat(bgrImage);

          bool ans;
          ans = getRedColor(input);
          theColorDetect.isThereRedColor = ans;

          OUTPUT_TEXT("The red color is there: " << theColorDetect.isThereRedColor);
      }

Explications
------------

Tout d'abord, il faut savoir qu'un module suit toujours une structure précise. Par exemple :

.. code-block:: cpp

   MODULE(SimpleBallLocator,
   {,
       REQUIRES(BallPercept),
       REQUIRES(FrameInfo),
       PROVIDES(BallModel),
       DEFINES_PARAMETERS(
       {,
           (Vector2f)(5.f, 0.f) offset,
           (float)(1.1f) scale,
       }),
   });

   class SimpleBallLocator : public SimpleBallLocatorBase
   {
       void update(BallModel& ballModel)
       {
           if(theBallPercept.wasSeen)
           {
               ballModel.position = theBallPercept.position * scale + offset;
               ballModel.wasLastSeen = theFrameInfo.time;
           }
       }
   };

Ensuite, pour notre module de détection d'objets rouges, nous allons procéder comme suit :

1. **Création des fichiers**  
   Créez deux fichiers : *ColorDetector.h* et *ColorDetector.cpp* que vous placerez dans le dossier ``Src/Modules/Perception/ColorPerceptors/``.

2. **Fichier d'en-tête (*.h*)**  
   - Commencez par un commentaire précisant le nom du fichier, l’objectif du module et l’auteur :

     .. code-block:: cpp

        /*
        * @file ColorDetector.h
        *
        * This file declares a module that detects red color in images with opencv.
        *
        * @author Louis Le Lay
        */

   - Incluez les représentations nécessaires (CameraInfo, CameraImage, ColorDetect).  
     (Référez-vous au tutoriel :ref:`representation` pour la création de *ColorDetect*).

     .. code-block:: cpp

        #include "Representations/Infrastructure/CameraInfo.h"
        #include "Representations/Infrastructure/CameraImage.h"
        #include "Representations/Perception/ColorDetects/ColorDetect.h"

   - Déclarez ensuite le module en précisant son nom, les représentations requises (*REQUIRES*) et celle fournie (*PROVIDES*).  
     Vous pouvez définir des paramètres si nécessaire, mais ce n'est pas le cas ici.

     .. code-block:: cpp

        MODULE (ColorDetector,
        {,
            REQUIRES(CameraInfo),
            REQUIRES(CameraImage),
            PROVIDES(ColorDetect),
        });

   - Déclarez la classe en respectant la convention de nommage (nom du module suivi de *Base*).

     .. code-block:: cpp

        class ColorDetector : public ColorDetectorBase
        {
            // Déclaration des méthodes et attributs privés
            void update(ColorDetect& theColorDetect) override;
        };

3. **Fichier d'implémentation (*.cpp*)**  
   - Comme pour le fichier d'en-tête, commencez par un commentaire expliquant le contenu du fichier.

     .. code-block:: cpp

        /**
        * @file ColorDetector.cpp
        *
        * This file declares a module that detects red color in images with opencv.
        *
        * @author Louis Le Lay
        */

   - Incluez ensuite le fichier d'en-tête, déclarez le module avec *MAKE_MODULE* et incluez les outils nécessaires :

     .. code-block:: cpp

        #include "ColorDetector.h"

        MAKE_MODULE(ColorDetector, perception);

        #include "Platform/File.h"

   - Pour la méthode *update*, notez que nous récupérons la représentation à mettre à jour (*theColorDetect*), 
     traitons l’image et affectons un booléen pour indiquer si l’objet rouge a été détecté. 
     Pour le débogage, un *OUTPUT_TEXT* est utilisé.

     .. code-block:: cpp

        void ColorDetector::update(ColorDetect& theColorDetect)
        {
            BGRImage bgrImage;
            bgrImage = theColorDetect.getBGRImage();

            cv::Mat input;
            input = BGRImageToMat(bgrImage);

            bool ans;
            ans = getRedColor(input);
            theColorDetect.isThereRedColor = ans;

            OUTPUT_TEXT("The red color is there: " << theColorDetect.isThereRedColor);
        }

En suivant cette logique, vous venez de créer un module qui détecte des objets rouges.
Passez maintenant au tutoriel suivant pour créer une représentation.
