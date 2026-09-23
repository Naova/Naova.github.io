Behavior Tree Reference
=======================

| **Project:** game.xml
| **Robot:** RoboCup Soccer Robot


----

Overview
--------

The tree is a single root ``Sequence``. On startup a ``RunOnce`` sets
``control_state=3`` (auto mode). Three priority blocks are checked
top-to-bottom every tick via ``ReactiveSequence _while``. The first
block whose condition is true wins; all lower-priority blocks are
skipped.

----

Control States — Priority Order
--------------------------------

State 1 — Manual / Assist Mode (highest priority)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Active when:** ``control_state==1`` or ``assist_kick`` or ``go_manual`` or ``assist_chase``

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - Go manual
     - Any joystick axis >0.1 → direct velocity control. LX/LY = move, RX = rotate.
   * - Assist chase
     - Hold LB → ``SimpleChase`` at vx=1.5 with no braking distance.
   * - Assist kick
     - Hold RB → ``Kick`` at speed=0.9, minimum 1000ms duration.
   * - Enter
     - LT+X sets ``control_state=1``
   * - Exit
     - Release all conditions, or press LT+B

.. image:: ../../_static/projects/behavior/diagrammanual.png
  :alt: Manual / Assist Mode
  :align: center

*Three independent branches: go manual, assist chase, assist kick.*

State 2 — Recalibrate / Re-enter Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Active when:** ``control_state==2``

.. list-table::
   :widths: 20 80
   :header-rows: 0

   * - If !calibrated
     - ``CamScanField`` — rotate head to find landmarks and localize via particle filter.
   * - If calibrated
     - ``CamFindAndTrackBall`` — keep eyes on ball ready to resume.
   * - Parallel
     - ``SelfLocateEnterField`` runs throughout — walks to re-entry position.
   * - Enter
     - LT+A sets ``control_state=2``
   * - Exit
     - Operator presses LT+B (no automatic exit)

.. image:: ../../_static/projects/behavior/diagramcalibrate.png
  :alt: Recalibrate / Re-enter Mode
  :align: center

*Localization loop: scan field until calibrated, then track ball.*

State 3 — Full Auto Mode (default)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Active when:** ``control_state==3 && !go_manual`` — set on startup

.. list-table::
   :widths: 15 85
   :header-rows: 0

   * - Step 1
     - ``AutoGetUpAndLocate`` — always runs first. Handles fall recovery.
   * - Step 2
     - If ``gc_is_under_penalty`` → stop, scan, wait to re-enter field.
   * - Step 3
     - Otherwise → game flow by sub-state type (see below).
   * - Enter
     - Startup (``RunOnce``) or LT+B
   * - Exit
     - Never — this is the default state

.. image:: ../../_static/projects/behavior/diagrammodeauto.png
  :alt: Mode Auto State Machine
  :align: center

*Three-phase mode auto flow: AutoGetUpAndLocate → WaitForPenalty → GameFlow.*

----

Auto Mode — Sub-state Types
-----------------------------

TIMEOUT
~~~~~~~

Stop all movement, scan field, track ball. Safe idle until game resumes.

NONE — Normal Play
~~~~~~~~~~~~~~~~~~

Driven by ``gc_game_state`` from the game controller:

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - Game state
     - Behavior
   * - INITIAL
     - Scan field to localize, track ball, walk to entry position. Loops until READY signal.
   * - READY
     - Look forward (``MoveHead pitch=0.35``), walk to kickoff position at vx=0.7, localize.
   * - SET
     - Track ball with camera, stop all movement, localize. Freeze and wait for kickoff.
   * - PLAY
     - Run ``StrikerPlay`` or ``GoalKeeperPlay`` subtree based on ``player_role``.
   * - END
     - Stop all movement. Match over.

.. image:: ../../_static/projects/behavior/diagramnormalgame.png
  :alt: Normal Game State Machine
  :align: center

*Four-phase normal game flow: INITIAL → READY → SET → PLAY.*

FREE_KICK — During PLAY
~~~~~~~~~~~~~~~~~~~~~~~~

Active when ``gc_game_sub_state_type == 'FREE_KICK'`` and ``gc_game_state == 'PLAY'``.
Driven by ``gc_game_sub_state``:

.. list-table::
   :widths: 15 85
   :header-rows: 1

   * - Phase
     - Behavior
   * - STOP
     - Track ball, localize if ``ball_location_known``, stop all movement.
   * - GET_READY
     - Localize, then run role-specific freekick subtree (``StrikerFreekick`` or ``GoalKeeperFreekick``).
   * - SET
     - Track ball, localize, stop all movement. Wait for kick signal.

.. image:: ../../_static/projects/behavior/diagramfreekick.png
  :alt: Free Kick State Machine
  :align: center

*Three-phase free kick flow: STOP → GET_READY → SET.*

----

Startup Sequence
-----------------

1. ``RunOnce`` sets ``control_state = 3``.
2. State 1 and State 2 checks are skipped — conditions false.
3. State 3 activates → ``AutoGetUpAndLocate`` runs.
4. Not penalized → sub-state NONE → ``gc_game_state = INITIAL``.
5. ``CamScanField`` until localized → ``CamFindAndTrackBall`` → ``SelfLocateEnterField``.
6. Loops in INITIAL until game controller sends READY signal.

.. image:: ../../_static/projects/behavior/diagramoverview.png
  :alt: Full Auto Mode Overview
  :align: center

*Top-level control flow: startup, modes, and sub-state routing.*

----

Example Robot Status
---------------------

.. list-table::
   :widths: 35 65
   :header-rows: 1

   * - Field
     - Value
   * - Team ID / Player ID
     - 29 / Player 1
   * - Number of players
     - 3
   * - Role
     - Striker (start role: striker)
   * - Control state
     - Auto (3)
   * - Game sub-state type
     - NONE
   * - Game state
     - INITIAL
   * - Kickoff side
     - NO
   * - Score
     - 0 : 0
   * - Live count / Oppo
     - 0 / 0
   * - Primary striker
     - YES

----

Key Design Patterns
--------------------

ReactiveSequence with ``_while``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The sequence only runs while its condition is true. The moment the
condition becomes false, the sequence exits immediately and the tree
falls through to the next sibling. This gives the tree its
priority-based, reactive feel — higher-priority states preempt lower
ones instantly.

``_autoremap="true"``
~~~~~~~~~~~~~~~~~~~~~~

All subtrees share the same blackboard automatically. Any key with the
same name in both the parent and subtree is connected without explicit
port mapping. Since ``brain.cpp`` writes entries like
``tree->setEntry<string>("player_role", ...)``, every subtree that
declares a port with that name gets the value automatically.

Role separation
~~~~~~~~~~~~~~~

The ``player_role`` blackboard key gates which subtree runs at PLAY and
GET_READY levels. The value is written by ``handleCooperation()`` in
``brain.cpp`` based on team negotiation and game state.

Actual soccer logic
~~~~~~~~~~~~~~~~~~~

The interesting behavior — chasing, kicking, positioning, defending —
lives entirely inside four subtrees:

- ``StrikerPlay``
- ``GoalKeeperPlay``
- ``StrikerFreekick``
- ``GoalKeeperFreekick``

----

Behavior Tree Diagrams
-----------------------

The following diagrams illustrate each state machine from the behavior
tree, as designed in draw.io.

Diagram 1 — Full Auto Mode Overview
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagramoverview.png
  :alt: Full Auto Mode Overview
  :align: center

*Top-level control flow: startup, modes, and sub-state routing.*

Diagram 2 — Manual / Assist Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagrammanual.png
  :alt: Manual / Assist Mode
  :align: center

*Three independent branches: go manual, assist chase, assist kick.*

Diagram 3 — Recalibrate / Re-enter Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagramcalibrate.png
  :alt: Recalibrate / Re-enter Mode
  :align: center

*Localization loop: scan field until calibrated, then track ball.*

Diagram 4 — Free Kick State Machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagramfreekick.png
  :alt: Free Kick State Machine
  :align: center

*Three-phase free kick flow: STOP → GET_READY → SET.*

Diagram 5 — Normal Game State Machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagramnormalgame.png
  :alt: Normal Game State Machine
  :align: center

*Four-phase normal game flow: INITIAL → READY → SET → PLAY.*

Diagram 5 — Mode Auto State Machine
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagrammodeauto.png
  :alt: Mode Auto State Machine
  :align: center

*Three-phase mode auto flow: AutoGetUpAndLocate → WaitForPenalty → GameFlow.*

Diagram 6 — Controller
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: ../../_static/projects/behavior/diagramcontroller.png
  :alt: Controller diagram
  :align: center

*All inputs*