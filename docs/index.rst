Naova K1 Project Documentation
==============================
.. figure:: source/_static/k1.jpg
   :width: 100%
   :alt: K1 robot standing

This documentation gathers the projects developed within Naova.

If you want to add your own project to the documentation,
see the :ref:`contributing` section.

Start Here
^^^^^^^^^^

To get the full and complete setup:

1. Ask a repository admin to add your GitHub account to our organization.
2. Ensure your `SSH key is added to GitHub <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>`_. , then verify access with:

   .. code-block:: bash

      ssh -T git@github.com

   See :ref:`installation` for detailed setup instructions.

3. If you need internal documentation, make sure you have access to the private wiki repository. 

   .. note::
      Our documentation is maintained in two repositories:

      - **Private wiki (internal work):** `NaovaPrivateWiki <https://github.com/Naova/NaovaPrivateWiki>`_.
      - **Public wiki (published externally):** `Naova.github.io <https://github.com/Naova/Naova.github.io>`_.

      The **private wiki** is mainly for projects in development.
      It is the more complete and current source of documentation. 

   If you have not cloned the private wiki repository yet, clone it:

   .. code-block:: bash

      git clone git@github.com:Naova/NaovaPrivateWiki.git

5. Update your local copy regularly to stay in sync with the latest changes:

   .. code-block:: bash

      cd NaovaPrivateWiki
      git pull origin main

6. Build the documentation locally to access it offline and see the latest updates:

   .. code-block:: bash

      ./naova.sh

7. Follow the installation guide to complete your local setup: :ref:`installation`.

8. Use :ref:`contributing` when you are ready to add or update documentation.

Documentation Map
^^^^^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2
   :caption: Getting Started

   source/configuration/installation
   source/configuration/irl
   source/configuration/simulation

.. toctree::
   :maxdepth: 1
   :caption: Core Concepts
   :titlesonly:

   source/overview/core_concepts

.. toctree::
   :maxdepth: 2
   :caption: Project Modules
   :titlesonly:

   source/projects/behavior/index
   source/projects/challenges/index
   source/projects/communication/index
   source/projects/motion-control/index
   source/projects/perception/index

.. toctree::
   :maxdepth: 2
   :caption: Guides
   :titlesonly:

   source/resources/how-to/index

.. toctree::
   :maxdepth: 1
   :caption: References

   source/refs/additional_resources
   source/refs/contributing
   source/refs/bibliography
   source/refs/changelog

Project and Community Links
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. toctree::
   :hidden:
   :caption: External Links

   GitHub <https://github.com/Naova/NaovaRelease>
   Naova <https://clubnaova.ca/>
   ETS <https://www.etsmtl.ca/>
   Legacy nao site <https://naova.github.io/nao>

License
^^^^^^^

Naova project documentation is open-source and distributed under the BSD-3-Clause license.
For details, see `BSD 3-Clause License
<https://github.com/Naova/Naova.github.io/blob/main/LICENSE>`_.

Acknowledgements
^^^^^^^^^^^^^^^^

Thanks to all Naova members for their contributions.
For the full list of project contributors,
see `CONTRIBUTORS.md <https://github.com/Naova/Naova.github.io/blob/main/CONTRIBUTORS.md>`_.