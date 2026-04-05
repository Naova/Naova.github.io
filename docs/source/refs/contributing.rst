.. _contributing:

How to Contribute
=================

Once you have completed a project at Naova, you will be asked to document it on this site.
This page will guide you through the process.

Steps to Follow
---------------

1. Run the following command to clone the repository:

.. code-block:: console
    
    git clone git@github.com:Naova/NaovaPrivateWiki.git

2. Next, enter the project directory:

.. code-block:: console

    cd NaovaPrivateWiki

3. To update your local repository with the latest state of the main branch, run:

.. code-block:: console

    git fetch origin
    git checkout main
    git reset --hard origin/main

4. Create a new branch with the following command:

.. code-block:: console
    
    git checkout -b your_project_name

5. Create a file named `your_project_name.rst` in the `docs/source/projects/` folder.

6. At the beginning of the file, add the following lines:

.. code-block:: RST
    
    .. _your_project_name:

    Title
    =====

Make sure to place an underscore before your project name and ensure that the equal signs under the title are the same length.

7.  Add your project to `index.rst` in the "Projects" section.

8.  Document your project in the `.rst` file. Once done, to build and open the documentation locally, enter:

.. tab-set::
   :sync-group: os

   .. tab-item:: :icon:`fa-brands fa-linux` Linux
      :sync: linux

      .. note::

         We have only tested this on Ubuntu 22.04 LTS.

      .. code:: console

         rm -rf docs/_build && ./naova.sh

   .. tab-item:: :icon:`fa-brands fa-windows` Windows
      :sync: windows

      .. note::

         TO TEST

      .. code:: console

         naova.bat

9.   Make sure your local Git credentials are up to date, or run:

.. code-block:: console
    
    git config --global user.email "email@example.com"
    git config --global user.name "username"

This is the user and email that will appear in the GitHub history.

10.  Run the following command to select the changes you want to add:

.. code-block:: console
    
    git add -p

11. Commit your changes with the following command:

.. code-block:: console
    
    git commit -m "Change description"

12. Push your branch to `origin` with the following command:

.. code-block:: console
    
    git push -u origin your_project_name

13. Go to `https://github.com/Naova/NaovaPrivateWiki` and open a new pull request.

14. In the `base` dropdown, select `main`, as you want to submit a PR to this branch.

15. In the `compare` dropdown, select your branch (`your_project_name`).

16. Review your changes and click `Create pull request`.

17. Wait for all automated tests to pass.

18. The PR will be approved or rejected after review by the team.

New Modifications
-----------------

To continue with a new modification, return to step 3.
To return to your PR and make new modifications:

1. Run the following command to stash your current changes:

.. code-block:: console
    
    git stash

2. Run the following command to return to your contribution branch:

.. code-block:: console
    
    git checkout your_project_name

3.  Repeat steps 10 and 11.

4.  Push your changes again with the following command:

.. code-block:: console
    
    git push origin your_project_name

The pull request will be automatically updated.


Good to Know About Writing in RST
----------------------------------

The **reStructuredText (RST)** language is used for technical documentation and is widely adopted by **Sphinx**.
Here are the main useful features for writing your documents effectively.


Inserting Links
^^^^^^^^^^^^^^^

There are several ways to add links in RST:

1. **Simple link embedded in text** ::

    See the official `Sphinx <https://www.sphinx-doc.org/>`_ documentation.

2. **Named link (reusable in multiple places in the document)** ::

    .. _sphinx-docs: https://www.sphinx-doc.org/

    Check out the `Sphinx documentation <sphinx-docs_>`_.


Text Formatting
^^^^^^^^^^^^^^^

- **Bold** : ``**Bold text**`` → **Bold text**  
- *Italic* : ``*Italic text*`` → *Italic text*  
- ``Monospace text`` : ```code``` → `code`
- Bullet list ::

   - Element 1
   - Element 2

- Numbered list ::

   1. First element
   2. Second element


Creating Subsections
^^^^^^^^^^^^^^^^^^^^

RST allows you to organize a document into sections and subsections using different punctuation marks ::

   Main Title
   ==========

   Section
   -------

   Subsection
   ^^^^^^^^^^

   Sub-subsection
   """"""""""""""


Inserting Images
^^^^^^^^^^^^^^^^

To add an image ::

   .. image:: source/_static/project_name/nao_robot.png
      :alt: Nao Robot
      :width: 300px
      :align: center

    This will display `source/_static/project_name/nao_robot.png` with a width of **300px** and centered.


Inserting Videos
^^^^^^^^^^^^^^^^

Videos can be embedded as links or via raw HTML if necessary:

1. **Link to a YouTube video** ::
    
    See the demonstration on YouTube: `RoboCup Video <https://www.youtube.com/watch?v=xvFZjo5PgG0>`_.


2. **HTML to directly embed a video** (requires `html` in Sphinx) ::

    .. raw:: html
        <iframe width="560" height="315" src="https://www.youtube.com/embed/xvFZjo5PgG0" frameborder="0" allowfullscreen></iframe>


References to Other Pages
^^^^^^^^^^^^^^^^^^^^^^^^^

It is possible to create links to other sections or pages of the documentation.

1. **Link to a section on the same page** ::

    See the section :ref:`Inserting Images <insertion-images>`.

   For this to work, the section must be marked with a **label** ::
    
    .. _insertion-images:

       Inserting Images
       ----------------

2. **Link to another documentation page** ::

    See also :ref:`other_page`

   where `other_page.rst` is a file in the same project.

3. **Link to a bibliographic reference** (with `sphinxcontrib-bibtex`) ::

    See the article :cite:`k1-kali2021walking`

   The citation must be defined in a `.bib` file included in the documentation.
