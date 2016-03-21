SwiftStack Fuel Plugin
======================

Allow Mirantis OpenStack environment able to use a running Swift cluster managed by SwiftStack Controller. SwiftStack fuel plugin disables the default Swift cluster that deployed on the Controller or Primary-Controller nodes, and then reconfigures Swift API endpoints, Keystone and Glance settings to the running SwiftStack Swift cluster.

Requirements
-----------

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
-----------

The plugin only supports a running SwiftStack Swift, able to reach from the OpenStack environment.
Make sure you have correct network configuration for the Swift cluster and OpenStack environment before you enable this plugin.
