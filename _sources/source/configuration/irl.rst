.. _irl:

==========================================
Physical Deployment
==========================================

This document outlines the procedures for connecting, building, and deploying software on the physical Booster K1 humanoid robot.

Reference Documentation
-----------------------
For complete technical specifications, refer to the official documentation:

* **K1 Instruction Manual:** https://booster.feishu.cn/wiki/AHctwLAYjiyThnkZctIc6iYunmf
* **Booster K1 3V3 Demo Deployment Guideline:** https://booster.feishu.cn/wiki/CQXowElA0iy2hhkmPJmcY0wwnHf
* **Robot Handling Tutorial Videos (in mandarin):** https://space.bilibili.com/3546665977907667/lists/7033720?type=season (Bilibili tutorials for physical robot handling)

SSH Connection
--------------

You can connect via wired Ethernet (recommended for initial setup) or Wi-Fi.

**Wired Connection:**

1. Connect an Ethernet cable from your PC to the robot's back panel.
2. Configure your PC's static IP:

   * **IP Address:** ``192.168.10.10``
   * **Netmask:** ``255.255.255.0``
   * **Gateway:** ``192.168.10.1``

3. Access the robot via terminal:

.. code-block:: bash

   ssh booster@192.168.10.102
   # Initial password: 123456

**Wireless Connection:**

Once connected via Ethernet, use ``nmtui`` to connect the robot to your local Wi-Fi network, then identify the new IP:

.. code-block:: bash

   ifconfig  # Note the wlan0 IP (e.g., 192.168.0.12)
   ssh booster@<your_robot_wifi_ip>

Build and Deployment
--------------------

Follow these steps to install the SDK and deploy the 3v3 Demo environment.

**1. SDK Installation:**

K1 also includes an onboard app that can be used to update the SDK directly on the robot.

.. code-block:: bash

   cd ~/Workspace
   git clone https://gitee.com/booster_robotics/sdk_release.git
   cd sdk_release
   sudo ./install.sh

**2. Compiling the 3v3 Demo:**

Ensure the ``Booster_K1_3v3_Demo.zip`` is uploaded to ``~/Workspace/`` and unzipped.

.. code-block:: bash

   cd ~/Workspace/Booster_K1_3v3_Demo/scripts/
   chmod +x *
   # Clean previous builds and compile
   sudo rm -rf ../build ../install
   ./build.sh

**3. Time Synchronization & Launch:**

Crucial for camera and sensor fusion functionality.

.. code-block:: bash

   # Synchronize camera time
   tar -zxvf chrony_patch.tar.gz
   cd chrony_patch && sudo ./update
   # Restart the robot after update

   # Execute the launch script
   cd ~/Workspace/Booster_K1_3v3_Demo/
   ./scripts/start.sh

General Handling & Safety
-------------------------

Proper physical handling is required to prevent hardware damage or injury.

**Video Tutorials:**

* **Robot Handling Tutorials:** https://space.bilibili.com/3546665977907667/lists/7033720?type=season

**Operational Modes:**

* **DAMP Mode:** Safety mode (motors exert no force). Used for storage or emergency stops.
* **PREP Mode:** Standing posture. Robot holds position but does not balance. **Must enter this mode before walking.**
* **WALK Mode:** Active balancing and locomotion enabled.

**Safety Rules:**

* **Never lift the robot while in WALK Mode.**
* **Surface Selection:** Perform dances and complex movements on rubber, concrete, or tile. Avoid carpets to prevent tripping.
* **Emergency Stop:** Use ``LT + Back`` on the joystick to enter DAMP mode immediately.
* **Stability:** K1 must first enter PREP mode and be placed in a stable standing position on the ground before switching to WALK mode.
* **Obstacles:** Clear all obstacles on the ground and avoid human proximity while operating K1.
* **Handling:** DO NOT touch any parts of K1 while under WALK mode, except for the handle.

**Powering on:**

1. Place K1 on its rest.
2. Install the battery pack. Slide the pack into the battery socket, with lights facing outwards.
3. Place K1's hands and legs in a natural posture.
4. Press **Power button** for about 3s (release after light turns on; pressing more than 6s powers off).
5. Wait about one minute for the prompt tone. The robot can then be remotely controlled.
   
   .. note:: 
      The initialization of IMU requires that K1 remains stationary during the booting process.

6. Press **LT + START** on the controller to enter PREP mode, then place K1 on the ground in a standing position.
7. Press **RT + A** to enter WALK mode. NOTE: DO NOT lift K1 while in WALK mode.

**Shutting down:**

1. Enter **PREP Mode (LT + Start)** and place the robot flat on the ground.
2. Enter **DAMP Mode (LT + Back)**.
3. Press and hold the **Power button** to shut down K1.
4. Wait at least 6 seconds after power-off before restarting.