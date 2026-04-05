.. _installation:

Installation
============

This page summarizes the recommended setup order for new contributors.
Use it as a quick onboarding checklist before diving into project-specific details.

Recommended order
*****************

1. Set up the wiki workflow first (branching, editing, PR process): :ref:`contributing`.
2. Set up the development codebase environment for K1 work: :ref:`installation-naovacodek1`.
3. Set up simulation in Webots to validate changes before hardware tests: :ref:`installation-webots`.

General Installation
=====================

.. note::
  **Prerequisites :**
   
  - Be a member of the GitHub organization "Naova"
  - Have Ubuntu (22.04) on your machine

Steps for general installation
******************************

1. Install the dependences :

.. code-block:: console

  sudo apt install git

2. Generate a SSH key and add it to GitHub :

- Generate the SSH key by executing :
    
  .. code-block:: console

    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
  
- Follow the instructions displayed to complete the generation.
- Copy the public key using the following command:

  .. code-block:: console

    cat ~/.ssh/id_rsa.pub

  (Copy the content displayed in your terminal.)
  
- Connect to your GitHub account and go to the **SSH and GPG keys** section to add your new key.

.. toctree::
   :maxdepth: 1
   :caption: Installation Guides

   installation/webots
   installation/naovacodek1