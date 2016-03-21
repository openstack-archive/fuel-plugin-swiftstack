
SwiftStack Fuel Plugin
----------------------

Allow Mirantis OpenStack environment able to use a running Swift cluster managed by SwiftStack Controller. SwiftStack fuel plugin disables the default Swift cluster that deployed on the Controller or Primary-Controller nodes, and then reconfigures Swift API endpoints, Keystone and Glance settings to the running SwiftStack Swift cluster.

Requirements
++++++++++++

+-----------------------------------+---------------------------------------------+
|Requirement                        | Version                                     |
+===================================+=============================================+
|Mirantis OpenStack compatibility   | 8.0                                         |
+-----------------------------------+---------------------------------------------+
|A running SwiftStack Swift cluster | All versions                                |
|                                   |                                             |
|                                   | Please enable **Keystone Auth** and         |
|                                   | **Keystone Auth Token Support** middlewares |
+-----------------------------------+---------------------------------------------+

Limitations
+++++++++++

The plugin only supports a running SwiftStack Swift, able to reach from the OpenStack environment.
Make sure you have correct network configuration for the Swift cluster and OpenStack environment before you enable this plugin.


Installation Guide
==================

#. Prepare `the Fuel Master node to install MOS 8.0 <http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide/install_install_fuel.html>`_.

#. Download the plugin from `Fuel Plugins Catalog <https://www.mirantis.com/validated-solution-integrations/fuel-plugins/>`_

#. Copy plugin to the Fuel Master node

    .. code-block:: bash

        $ scp swiftstack-0.2-0.2.0-1.noarch.rpm root@<THE_FUEL_MASTER_NODE_IP>:/tmp/ 

#. Install SwiftStack plugin 

    .. code-block:: bash

        [root@fuel ~]$ fuel plugins --install swiftstack-0.2-0.2.0-1.noarch.rpm 

#. List all Fuel plugins and make sure it’s running:

    .. code-block:: bash

        [root@fuel ~]$ fuel plugins 

        id | name       | version | package_version
        ---|------------|---------|----------------
        2  | swiftstack | 0.2.0   | 3.0.0







