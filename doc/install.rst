Installation Guide
==================

Prepare Fuel Environment
------------------------
#. Prepare a Fuel Master node to install `MOS 8.0`_ 

#. Download plugin from `Fuel Plugins Catalog`_

.. _MOS 8.0: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide/install_install_fuel.html
.. _Fuel Plugins Catalog: https://www.mirantis.com/validated-solution-integrations/fuel-plugins/


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



