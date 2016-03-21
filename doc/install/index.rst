Installation Guide
++++++++++++++++++

.. toctree::
    :maxdepth: 3

Prepare Fuel Environment and build SwiftStack Plugin
----------------------------------------------------

1. Prepare a Fuel-Master-Node to install MOS 8.0 
2. Download plugin from Fuel Plugins Catalog

or you can build it by yourself as following:

    .. code-block:: bash

        # Create a virtualenv for Fuel to build plugin
        $ sudo apt-get install python-dev python-pip python-virtualenv
        $ virtualenv fuel

        # Clone fule-plugin-builder and SwiftStack Swift Fuel plugin
        $ git clone https://github.com/openstack/fuel-plugins
        $ git clone https://github.com/openstack/fuel-plugin-swiftstack

        $ source fuel/bin/activate
        (fuel) $ cd fuel-plugins/fuel_plugin_builder/
        (fuel) fuel-plugins/fuel_plugin_builder $ pip install -e .

        (fuel) $ cd fuel_plugin_swiftstack/
        (fuel) fuel_plugin_swiftstack $ fpb --build ./
        Plugin is built


Install Plugin
--------------

1. Copy plugin to Fuel-Master-Node

.. code-block:: bash

    $ scp swiftstack-0.2-0.2.0-1.noarch.rpm root@10.20.0.2:/tmp/ 

2. Install SwiftStack plugin 

.. code-block:: bash

    [root@fuel ~]$ fuel plugins --install swiftstack-0.2-0.2.0-1.noarch.rpm 

3. List all Fuel plugins and make sure it’s running

.. code-block:: bash

    [root@fuel ~]$ fuel plugins 

    id | name       | version | package_version
    ---|------------|---------|----------------
    2  | swiftstack | 0.2.0   | 3.0.0



