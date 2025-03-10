.. _modify-module:

Modifier un module existant
===========================

Dans ce tutoriel, nous allons voir comment modifier un module existant en prenant toujours pour exemple la détection d’un objet rouge via la caméra.

Le code
-------

.. dropdown:: Code pour *LEDHandler.h*  
   :icon: code

   .. code-block:: cpp
      :linenos:
      :emphasize-lines: 22, 38

      /**
      * @file LEDHandler.h
      * This file implements a module that generates the LEDRequest from certain representations.
      * @author jeff
      */

      #pragma once

      #include "Representations/BehaviorControl/TeamBehaviorStatus.h"
      #include "Representations/Communication/GameInfo.h"
      #include "Representations/Communication/RobotInfo.h"
      #include "Representations/Communication/TeamData.h"
      #include "Representations/Communication/TeamInfo.h"
      #include "Representations/Infrastructure/FrameInfo.h"
      #include "Representations/Infrastructure/LEDRequest.h"
      #include "Representations/Infrastructure/SensorData/SystemSensorData.h"
      #include "Representations/Modeling/BallModel.h"
      #include "Representations/Perception/FieldFeatures/FieldFeatureOverview.h"
      #include "Representations/Sensing/GroundContactState.h"
      #include "Tools/Module/Module.h"
      #include "Representations/Infrastructure/RobotHealth.h"
      #include "Representations/Perception/ColorDetects/ColorDetect.h"

      MODULE(LEDHandler,
      {,
         REQUIRES(BallModel),
         REQUIRES(FieldFeatureOverview),
         REQUIRES(FrameInfo),
         REQUIRES(GameInfo),
         REQUIRES(GroundContactState),
         REQUIRES(JointSensorData),
         REQUIRES(OwnTeamInfo),
         REQUIRES(RobotInfo),
         USES(RobotHealth),
         REQUIRES(SystemSensorData),
         REQUIRES(TeamBehaviorStatus),
         REQUIRES(TeamData),
         REQUIRES(ColorDetect),  
         PROVIDES(LEDRequest),
         DEFINES_PARAMETERS(
         {,
            (int)(5) chargingLightSlowness,
            (int)(2000) gameControllerTimeOut,
            (int)(50) tempForHalfLEDActive,
            (int)(65) tempForLEDBlinking,
            (int)(75) tempForLEDFastBlinking,
         }),
      });

      class LEDHandler : public LEDHandlerBase
      {
      public:
         ENUM(EyeColor,
         {,
            red,
            green,
            blue,
            white,
            magenta,
            yellow,
            cyan,
         });

      private:
         void update(LEDRequest& ledRequest) override;

         void setEyeColor(LEDRequest& ledRequest,
                          bool left,
                          EyeColor col,
                          LEDRequest::LEDState s);

         void setBatteryLevelInEar(LEDRequest& ledRequest, LEDRequest::LED baseLED);

         void setRightEar(LEDRequest& ledRequest);
         void setLeftEar(LEDRequest& ledRequest);
         void setLeftEye(LEDRequest& ledRequest);
         void setRightEye(LEDRequest& ledRequest);
         void setHead(LEDRequest& ledRequest);
         void setChestButton(LEDRequest& ledRequest);
         void setLeftFoot(LEDRequest& ledRequest);
         void setRightFoot(LEDRequest& ledRequest);

         size_t chargingLED = 0;
         const LEDRequest::LED headLEDCircle[LEDRequest::numOfHeadLEDs] =
         {
            LEDRequest::headRearLeft2,
            LEDRequest::headRearLeft1,
            LEDRequest::headRearLeft0,
            LEDRequest::headMiddleLeft0,
            LEDRequest::headFrontLeft0,
            LEDRequest::headFrontLeft1,
            LEDRequest::headFrontRight1,
            LEDRequest::headFrontRight0,
            LEDRequest::headMiddleRight0,
            LEDRequest::headRearRight0,
            LEDRequest::headRearRight1,
            LEDRequest::headRearRight2
         };
      };

.. dropdown:: Code pour *LEDHandler.cpp*  
   :icon: code

   .. code-block:: cpp
      :linenos:
      :emphasize-lines: 138, 146-147

      /**
      * @file LEDHandler.cpp
      * This file implements a module that generates the LEDRequest from certain representations.
      * @author jeff
      * @author <a href="mailto:jesse@tzi.de">Jesse Richter-Klug</a>
      */

      #include "LEDHandler.h"

      #include <algorithm>

      void LEDHandler::update(LEDRequest& ledRequest)
      {
         //reset
         FOREACH_ENUM(LEDRequest::LED, led)
            ledRequest.ledStates[led] = LEDRequest::off;

         setRightEye(ledRequest);
         setLeftEye(ledRequest);
         setChestButton(ledRequest);
         setLeftFoot(ledRequest);
         setRightFoot(ledRequest);

         //update
         setRightEar(ledRequest);
         setLeftEar(ledRequest);
         setHead(ledRequest);
      }

      void LEDHandler::setRightEar(LEDRequest& ledRequest)
      {
         //right ear -> battery
         setBatteryLevelInEar(ledRequest, LEDRequest::earsRight0Deg);
      }

      void LEDHandler::setLeftEar(LEDRequest& ledRequest)
      {
         //left ear -> connected players
         //          + GameController connection lost -> freaky blinking
         if(theFrameInfo.getTimeSince(theGameInfo.timeLastPacketReceived) > gameControllerTimeOut)
         {
            ledRequest.ledStates[LEDRequest::earsLeft324Deg] = LEDRequest::blinking;
            ledRequest.ledStates[LEDRequest::earsLeft144Deg] = LEDRequest::blinking;
         }

         int numberOfConnectedTeammates = static_cast<int>(theTeamData.teammates.size());
         if(numberOfConnectedTeammates > 0)
         {
            ledRequest.ledStates[LEDRequest::earsLeft0Deg] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::earsLeft36Deg] = LEDRequest::on;
         }
         if(numberOfConnectedTeammates > 1)
         {
            ledRequest.ledStates[LEDRequest::earsLeft72Deg] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::earsLeft108Deg] = LEDRequest::on;
         }
         if(numberOfConnectedTeammates > 2)
         {
            ledRequest.ledStates[LEDRequest::earsLeft180Deg] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::earsLeft216Deg] = LEDRequest::on;
         }
         if(numberOfConnectedTeammates > 3)
         {
            ledRequest.ledStates[LEDRequest::earsLeft252Deg] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::earsLeft288Deg] = LEDRequest::on;
         }
      }

      void LEDHandler::setEyeColor(LEDRequest& ledRequest,
                                   bool left,
                                   EyeColor col,
                                   LEDRequest::LEDState s)
      {
         LEDRequest::LED first = left ? LEDRequest::faceLeftRed0Deg : LEDRequest::faceRightRed0Deg;

         static const int redOffset = 0,
                          greenOffset = LEDRequest::faceLeftGreen0Deg - LEDRequest::faceLeftRed0Deg,
                          blueOffset = LEDRequest::faceLeftBlue0Deg - LEDRequest::faceLeftRed0Deg,
                          numOfLEDsPerColor = LEDRequest::faceLeftRed315Deg - LEDRequest::faceLeftRed0Deg;

         LEDRequest::LEDState halfState = s == LEDRequest::off ? LEDRequest::off : LEDRequest::half;

         switch(col)
         {
            case red:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + redOffset + i] = s;
               break;
            case green:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + greenOffset + i] = s;
               break;
            case blue:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + blueOffset + i] = s;
               break;
            case white:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + redOffset + i] = s;
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + greenOffset + i] = s;
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + blueOffset + i] = s;
               break;
            case magenta:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + redOffset + i] = halfState;
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + blueOffset + i] = s;
               break;
            case yellow:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + greenOffset + i] = halfState;
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + redOffset + i] = s;
               break;
            case cyan:
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + greenOffset + i] = halfState;
               for(int i = 0; i <= numOfLEDsPerColor; i++)
                  ledRequest.ledStates[first + blueOffset + i] = s;
               break;
            default:
               FAIL("Unknown color.");
               break;
         }
      }

      void LEDHandler::setLeftEye(LEDRequest& ledRequest)
      {
         //no groundContact
         if(!theGroundContactState.contact/* && (theFrameInfo.time & 512)*/)
            setEyeColor(ledRequest, true, yellow, LEDRequest::on);
         else
         {
            bool ballSeen = theFrameInfo.getTimeSince(theBallModel.timeWhenLastSeen) < 250;
            bool featureSeen = theFrameInfo.getTimeSince(theFieldFeatureOverview.combinedStatus.lastSeen) < 250;
            bool redPresent = theRefereePosePercept.isThereRedColor;

            if(ballSeen && featureSeen)
               setEyeColor(ledRequest, true, red, LEDRequest::on);
            else if(ballSeen)
               setEyeColor(ledRequest, true, white, LEDRequest::on);
            else if(featureSeen)
               setEyeColor(ledRequest, true, blue, LEDRequest::on);
            else if(redPresent)
               setEyeColor(ledRequest, true, green, LEDRequest::on);
         }
      }

      void LEDHandler::setRightEye(LEDRequest& ledRequest)
      {
         if(theTeamBehaviorStatus.role.playsTheBall())
            setEyeColor(ledRequest, false, red, LEDRequest::on);
         else if(theTeamBehaviorStatus.role.isGoalkeeper())
            setEyeColor(ledRequest, false, blue, LEDRequest::on);
         else if(theTeamBehaviorStatus.role.supporterIndex() == 0)
            setEyeColor(ledRequest, false, white, LEDRequest::on);
         else if(theTeamBehaviorStatus.role.supporterIndex() == 1)
            setEyeColor(ledRequest, false, yellow, LEDRequest::on);
         else if(theTeamBehaviorStatus.role.supporterIndex() == 2)
            setEyeColor(ledRequest, false, green, LEDRequest::on);
         else if(theTeamBehaviorStatus.role.supporterIndex() == 3)
            setEyeColor(ledRequest, false, cyan, LEDRequest::on);
      }

      void LEDHandler::setHead(LEDRequest& ledRequest)
      {
         for(unsigned i = LEDRequest::headRearLeft0; i <= LEDRequest::headMiddleLeft0; i++)
            ledRequest.ledStates[i] = LEDRequest::off;

         if(theSystemSensorData.batteryCharging)
         {
            for(LEDRequest::LED i = LEDRequest::firstHeadLED; i <= LEDRequest::lastHeadLED; i = LEDRequest::LED(unsigned(i) + 1))
               ledRequest.ledStates[i] = LEDRequest::off;

            ++chargingLED %= (LEDRequest::numOfHeadLEDs * chargingLightSlowness);
            const LEDRequest::LED currentLED = headLEDCircle[chargingLED / chargingLightSlowness];
            const LEDRequest::LED nextLED = headLEDCircle[(chargingLED / chargingLightSlowness + 1u) % LEDRequest::numOfHeadLEDs];
            ledRequest.ledStates[currentLED] = LEDRequest::on;
            ledRequest.ledStates[nextLED] = LEDRequest::on;
         }
      }

      void LEDHandler::setChestButton(LEDRequest& ledRequest)
      {
         switch(theRobotInfo.mode)
         {
            case RobotInfo::unstiff:
               ledRequest.ledStates[LEDRequest::chestBlue] = LEDRequest::blinking;
               break;
            case RobotInfo::calibration:
               ledRequest.ledStates[LEDRequest::chestRed] = LEDRequest::on;
               ledRequest.ledStates[LEDRequest::chestBlue] = LEDRequest::on;
               break;
            case RobotInfo::active:
            default:
               if(theRobotInfo.penalty != PENALTY_NONE)
                  ledRequest.ledStates[LEDRequest::chestRed] = LEDRequest::on;
               else
                  switch(theGameInfo.state)
                  {
                     case STATE_READY:
                        ledRequest.ledStates[LEDRequest::chestBlue] = LEDRequest::on;
                        break;
                     case STATE_SET:
                        ledRequest.ledStates[LEDRequest::chestRed] = LEDRequest::on;
                        ledRequest.ledStates[LEDRequest::chestGreen] = LEDRequest::half;
                        break;
                     case STATE_PLAYING:
                        ledRequest.ledStates[LEDRequest::chestGreen] = LEDRequest::on;
                        break;
                  }
         }
      }

      void LEDHandler::setLeftFoot(LEDRequest& ledRequest)
      {
         switch(theOwnTeamInfo.teamColor)
         {
            case TEAM_ORANGE:
               ledRequest.ledStates[LEDRequest::footLeftGreen] = LEDRequest::half;
            case TEAM_RED:
               ledRequest.ledStates[LEDRequest::footLeftRed] = LEDRequest::on;
               break;
            case TEAM_WHITE:
               ledRequest.ledStates[LEDRequest::footLeftBlue] = LEDRequest::on;
            case TEAM_YELLOW:
               ledRequest.ledStates[LEDRequest::footLeftRed] = LEDRequest::on;
            case TEAM_GREEN:
               ledRequest.ledStates[LEDRequest::footLeftGreen] = LEDRequest::on;
               break;
            case TEAM_PURPLE:
               ledRequest.ledStates[LEDRequest::footLeftRed] = LEDRequest::on;
            case TEAM_BLUE:
               ledRequest.ledStates[LEDRequest::footLeftBlue] = LEDRequest::on;
               break;
            case TEAM_GRAY:
               ledRequest.ledStates[LEDRequest::footLeftBlue] = LEDRequest::half;
            case TEAM_BROWN: // more a darker yellow
               ledRequest.ledStates[LEDRequest::footLeftRed] = LEDRequest::half;
               ledRequest.ledStates[LEDRequest::footLeftGreen] = LEDRequest::half;
               break;
         }
      }

      void LEDHandler::setRightFoot(LEDRequest& ledRequest)
      {
         if(theGameInfo.state == STATE_INITIAL &&
            theGameInfo.gamePhase == GAME_PHASE_PENALTYSHOOT &&
            theGameInfo.kickingTeam == theOwnTeamInfo.teamNumber)
            ledRequest.ledStates[LEDRequest::footRightGreen] = LEDRequest::on;
         else if(theGameInfo.state == STATE_INITIAL &&
                 theGameInfo.gamePhase == GAME_PHASE_PENALTYSHOOT &&
                 theGameInfo.kickingTeam != theOwnTeamInfo.teamNumber)
         {
            ledRequest.ledStates[LEDRequest::footRightRed] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::footRightGreen] = LEDRequest::on;
         }
         else if(theFrameInfo.getTimeSince(theGameInfo.timeLastPacketReceived) < gameControllerTimeOut &&
                 theGameInfo.state <= STATE_SET &&
                 theGameInfo.kickingTeam == theOwnTeamInfo.teamNumber)
         {
            ledRequest.ledStates[LEDRequest::footRightRed] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::footRightGreen] = LEDRequest::on;
            ledRequest.ledStates[LEDRequest::footRightBlue] = LEDRequest::on;
         }
      }

      void LEDHandler::setBatteryLevelInEar(LEDRequest& ledRequest, LEDRequest::LED baseLED)
      {
         int onLEDs = std::min(static_cast<int>(theSystemSensorData.batteryLevel / 0.1f), 9);

         for(int i = 0; i <= onLEDs; ++i)
            ledRequest.ledStates[baseLED + i] = LEDRequest::on;
      }

      MAKE_MODULE(LEDHandler, behaviorControl);

Explications
------------

Dans cet exemple, l'objectif est de modifier la couleur des yeux afin qu'elle reflète la détection de la couleur rouge par la caméra.  
Pour ce faire, nous devons adapter les modules responsables de l'affichage des LED dans les yeux lorsque la représentation de détection de rouge est activée.

Les étapes à suivre sont les suivantes :

1. **Inclusion de la représentation :**  
   Dans le fichier *LEDHandler.h*, incluez le fichier de la représentation en ajoutant :

   .. code-block:: cpp

      #include "Representations/Perception/ColorDetects/ColorDetect.h"

2. **Mise à jour des dépendances :**  
   Ajoutez la représentation dans la liste des *REQUIRES* :

   .. code-block:: cpp

      REQUIRES(ColorDetect),

3. **Modification de la méthode concernée :**  
   Dans le fichier *LEDHandler.cpp*, modifiez la méthode *setLeftEye* pour intégrer la nouvelle logique.  
   Par exemple, récupérez la valeur de la détection de rouge :

   .. code-block:: cpp

      bool redPresent = theRefereePosePercept.isThereRedColor;

   Ensuite, ajoutez une condition dans la séquence de choix de couleur pour activer la LED verte lorsque du rouge est détecté :

   .. code-block:: cpp
      :emphasize-lines: 7-8

      if(ballSeen && featureSeen)
         setEyeColor(ledRequest, true, red, LEDRequest::on);
      else if(ballSeen)
         setEyeColor(ledRequest, true, white, LEDRequest::on);
      else if(featureSeen)
         setEyeColor(ledRequest, true, blue, LEDRequest::on);
      else if(redPresent)
         setEyeColor(ledRequest, true, green, LEDRequest::on);

Ainsi, vous adaptez le comportement du module LEDHandler pour que la couleur affichée dans l'œil gauche change en fonction de la détection de la couleur rouge par la caméra.
Vous pouvez maintenant passer aux tests avec le tutoriel suivant.