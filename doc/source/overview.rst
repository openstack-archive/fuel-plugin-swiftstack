SwiftStack Fuel Plugin
======================

Allow Mirantis OpenStack environment able to use a running Swift cluster managed by  
a SwiftStack Controller. In SwiftStack fuel plugin, it disables the default Swift cluster 
on Controller and Primary-Controller nodes, and then reconfigures Swift API endpoints, 
Keystone, Glance settings and point them to a running SwiftStack Swift cluster.


Key terms, acronyms and abbreviations
-------------------------------------

SwiftStack On-Premises controller
    Provides a management service inside user's private place to help users to deploy 
    and manage Swift clusters.

SwiftStack Public Controller
    Provides a public management service in public cloud that help users to deploy and 
    manage Swift clusters.

SwiftStack Nodes
    A node installed SwiftStack agents and packages, that can be managed by a 
    SwiftStack Controller, the node could be assigned a Swift role likes ``Swift node``
    (Proxy/Account/Container/Object services are running in a single node)

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

The plugin only supports a running SwiftStack Swift cluster and it able to reach 
from the OpenStack environment. Make sure you have the correct network configuration 
for the Swift cluster and Mirantis OpenStack environment before you enable this plugin.



Known issues
------------

#. Need DNS server support to map Swift APIs hostname and IP

    SwiftStack provides a software load balancer, which requries an external DNS server
    to operate. Please use DNS server insteand of static hostname records in /etc/hosts.

#. Self-signed SSL certificates are not supported in the SwiftStack plugin

    Self-signed certificates could be an issue when used in a production environment 
    because all clients need to trust the cert to pass the TLS/SSL verification.
    It is highly recommended to use certificates signed by a known, trusted Certificate 
    Authority if you require TLS/SSL for your Swift cluster endpoint.

#. Integration with `LDAP Fuel plugin`_ (You can find the validated rpm `from Mirantis`_).

    LDAP Fuel plugin can integrate your LDAP server as a Keystone Identity provider, and that 
    requires some pre-create OUs and Group on the LDAP server. If you have some existed users
    conflict with OpenStack environment (i.e., swift, heat, .., etc), that causes the deployment
    failed. And SwiftStack Fuel plugin will try to create Swift user for Swift service in Keystone 
    DB, please make sure you don't have an existed user called ``Swift`` on your LDAP server. 
    And Here is a `document`_ to help you setup these OUs and Groups.


.. _LDAP Fuel plugin: https://github.com/openstack/fuel-plugin-ldap 
.. _from Mirantis: https://www.mirantis.com/validated-solution-integrations/fuel-plugins/
.. _document: https://wiki.openstack.org/wiki/OpenLDAP


