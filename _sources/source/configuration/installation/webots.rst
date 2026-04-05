.. _installation-webots:

Webots Installation
===================
Webots is software for robotics simulation developed by Cyberbotics. It allows you to create, simulate, 
and control robots in a 3D virtual environment. 

To install Webots, follow these steps:

1. Download the files from `our latest release <https://github.com/Naova/NaovaWebots/releases>`_. 
  Leave the files in the Downloads folder for now.

2. Clone the Git repository:

.. code-block:: console

  git@github.com:Naova/NaovaWebots.git

3. Run the installation script:

- Move to the cloned folder:

  .. code-block:: console

    cd NaovaWebots

- Give execution rights to the script:

  .. code-block:: console

    chmod +x install_webots.sh

- Execute the script:

  .. code-block:: console

    ./install_webots.sh

4. Test the installation by launching Webots:
The script can be launched from anywhere with the following command:
  
.. code-block:: console

  webots

5. You can copy `booster-runner-full-webots-k1-0.0.1.run` from the Downloads folder to the Webots installation directory (e.g., /usr/local/webots) and run it to configures the Webots-K1 environment before each simulation session.
