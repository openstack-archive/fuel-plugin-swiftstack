SwiftStack Fuel Plugin Documentation
************************************

SwiftStack Fuel Plugin
++++++++++++++++++++++

Allow Mirantis OpenStack environment able to use a running Swift cluster managed by SwiftStack Controller. SwiftStack fuel plugin disables the default Swift cluster that deployed on the Controller or Primary-Controller nodes, and then reconfigures Swift API endpoints, Keystone and Glance settings to the running SwiftStack Swift cluster.

Requirements
------------

+-----------------------------------+---------------------------------------------+
|Requirement                        | Version                                     |
+===================================+=============================================+
|Mirantis OpenStack compatibility   | **8.0** or higher                           |
+-----------------------------------+---------------------------------------------+
|A running SwiftStack Swift cluster | All version                                 |
|                                   |                                             |
|                                   | Please enable **Keystone Auth** and         |
|                                   | **Keystone Auth Token Support** middlewares |
+-----------------------------------+---------------------------------------------+

Limitations
-----------

The plugin only support a running SwiftStack Swift cluster and it ables to reach from the OpenStack environment. Make sure you have correct network configureation for the Swift cluster and OpenStack environment before you enable this plugin.


Guides
------

.. toctree::
    :maxdepth: 1
    
    install/index
    user/index


