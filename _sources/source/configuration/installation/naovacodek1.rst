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


Install core build tools first:

.. code-block:: bash

	sudo apt-get update
	sudo apt-get install -y python3-colcon-common-extensions python3-rosdep
	sudo rosdep init
	rosdep update

Install required system libraries:

.. code-block:: bash

	sudo apt-get install -y \
		libopencv-dev \
		libpcl-dev \
		libeigen3-dev \
		libyaml-cpp-dev \
		libpcap-dev \
		ros-humble-backward-ros


1. Install Booster Robotics SDK
--------------------------------
Follow the official `Booster Robotics SDK installation guide <https://github.com/BoosterRobotics/booster_robotics_sdk>`_ :

.. code-block:: bash

	cd ~/naova/
	git clone https://github.com/BoosterRobotics/booster_robotics_sdk.git
	cd booster_robotics_sdk
	sudo ./install.sh

2. Clone NaovaCodeK1 repository
--------------------------------
If you do not have the repository yet:

.. code-block:: bash
	
	cd ~/naova/
	git clone git@github.com:Naova/NaovaCodeK1.git
	cd NaovaCodeK1

3. Install extra dependencies
------------------------------

Install remaining ROS package dependencies from this workspace:

.. code-block:: bash

	source /opt/ros/humble/setup.bash
	rosdep install --from-paths src --ignore-src -r -y

For **build without CUDA** (ONNX inference), install ONNX Runtime first.

On aarch64:

.. code-block:: bash

	cd ~/naova/NaovaCodeK1
	# aarch64
	./third_party_aarch64/install_onnxruntime.sh

On x86_64:

.. code-block:: bash

	cd ~/naova/NaovaCodeK1
	# x86_64
	./third_party/install_onnxruntime.sh

Build
-----

.. important::
	Most users should use the **without CUDA** flow unless they have a GPU (Nvidia GeForce RTX 5050 or higher) that
	supports CUDA Compute Capability **12.0** or higher.

Build without CUDA (requires ONNX Runtime):

.. code-block:: bash

	./scripts/build_no_cuda.sh

Build with CUDA (real robot):

.. code-block:: bash

	./scripts/build.sh

Shell environment (important):

In each new terminal, source ROS first, then this workspace overlay:

.. code-block:: bash

	source /opt/ros/humble/setup.bash
	source install/setup.bash

Notes:

- If you only source ``/opt/ros/humble/setup.bash``, this workspace packages are not overlaid.
- After any ``colcon build``, run ``source install/setup.bash`` again in that terminal.

Run
---

Simulation (virtual robot):

For first-time setup, copy the example local override files once:

.. code-block:: bash

	cp src/brain/config/config_local.example.yaml src/brain/config/config_local.yaml
	cp src/vision/config/vision_local.example.yaml src/vision/config/vision_local.yaml

Then start simulation:

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

Config precedence:

1. ``config.yaml`` / ``vision.yaml``
2. ``config_local.yaml`` / ``vision_local.yaml``
3. ``~/agents/booster_soccer/brain.yaml`` / ``~/agents/booster_soccer/vision.yaml``

JetPack 6.2 note:

This repository supports JetPack 6.2 and is adapted to the default TensorRT
model configured in ``src/vision/config/vision.yaml``.

.. code-block:: yaml

	detection_model:
		model_path: ./src/vision/model/best_digua_second_10.3.engine
		confidence_threshold: 0.2

