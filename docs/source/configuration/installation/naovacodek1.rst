.. _installation-naovacodek1:

NaovaCodeK1 Installation
========================

This page explains how to install, build, and run **NaovaCodeK1**.

.. note::
	Target platform: **Ubuntu 22.04 (Jammy)**.

Prerequisites
-------------

You need:

- A Linux machine with Ubuntu 22.04
- A user account with ``sudo`` permissions
- Internet access (for package downloads)
- Around 20+ GB free disk space (more if installing vision dependencies)
- ROS2 Humble already installed

Open a terminal and move to the project root:

.. code-block:: bash

	cd /path/to/NaovaCodeK1

If you do not have the repository yet:

.. code-block:: bash

	git clone git@github.com:Naova/NaovaCodeK1.git
	cd NaovaCodeK1

Install Booster Robotics SDK
-----------------------------
Follow the official `Booster Robotics SDK installation guide <https://github.com/BoosterRobotics/booster_robotics_sdk>`_ :

.. code-block:: bash

	cd /path/to/booster_sdk
	git clone https://github.com/BoosterRobotics/booster_robotics_sdk.git
	cd booster_robotics_sdk
	sudo ./install.sh

Install extra dependencies
--------------------------

Install ``backward-ros``:

.. code-block:: bash

	sudo apt-get install ros-humble-backward-ros

For **build without CUDA** (ONNX inference), install ONNX Runtime first:

.. code-block:: bash

	# aarch64
	./third_party_aarch64/install_onnxruntime.sh

.. code-block:: bash

	# x86_64
	./third_party/install_onnxruntime.sh

Build
-----

.. important::
	Most users should use the **without CUDA** flow unless they have a GPU that
	supports CUDA Compute Capability **5.0** or higher.

Build without CUDA (requires ONNX Runtime):

.. code-block:: bash

	./scripts/build_no_cuda.sh

Build with CUDA (real robot):

.. code-block:: bash

	./scripts/build.sh

Run
---

Simulation (virtual robot):

.. code-block:: bash

	./scripts/sim_start.sh

Local runs use the committed local override files directly:

- ``src/brain/config/config_local.yaml``
- ``src/vision/config/vision_local.yaml``

The launch files load the base config first, then the local override file, and
finally the machine-specific files in ``~/agents/booster_soccer/`` if they
exist. This keeps the team-shared local defaults in git while still allowing
robot-specific values on the hardware.

Real robot:

.. code-block:: bash

	./scripts/start.sh

Real robot runs use the same launch flow, but the local override files contain
the real-robot values instead of the simulation values.

Configuration notes
-------------------

JetPack 6.2 note:

This repository supports JetPack 6.2 and is adapted to the default TensorRT
model configured in ``src/vision/config/vision.yaml``.

.. code-block:: yaml

	detection_model:
		model_path: ./src/vision/model/best_digua_second_10.3.engine
		confidence_threshold: 0.2

