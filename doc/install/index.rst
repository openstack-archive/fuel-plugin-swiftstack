Installation Guide
==================

Build SwiftStack Plugin
-----------------------

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

    .. note::

        The plugin should be ready in Fuel Plugins Catalog, you can skip this step and dowload it directly.

Prepare Fuel Environment
------------------------
#. Prepare a Fuel Master node to install MOS 8.0 

   http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide/install_install_fuel.html

#. Download plugin from Fuel Plugins Catalog

   https://www.mirantis.com/validated-solution-integrations/fuel-plugins/


Install Plugin
--------------

#. Copy plugin to the Fuel Master node

    .. code-block:: bash

        $ scp swiftstack-0.2-0.2.0-1.noarch.rpm root@<THE_FUEL_MASTER_NODE_IP>:/tmp/ 

#. Install SwiftStack plugin 

    .. code-block:: bash

        [root@fuel ~]$ fuel plugins --install swiftstack-0.2-0.2.0-1.noarch.rpm 

#. List all Fuel plugins and make sure it’s running

    .. code-block:: bash

        [root@fuel ~]$ fuel plugins 

        id | name       | version | package_version
        ---|------------|---------|----------------
        2  | swiftstack | 0.2.0   | 3.0.0



