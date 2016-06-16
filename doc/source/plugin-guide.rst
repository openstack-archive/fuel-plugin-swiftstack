************************************************************
Guide to the SwiftStack Plugin version 0.3-0.3.0-1 for Fuel
************************************************************

This document provides instructions for installing, configuring and using
SwiftStack plugin for Fuel.

Key terms, acronyms and abbreviations
=====================================

SwiftStack On-Premises controller
    Provides a management service inside user's private place to help users to deploy 
    and manage Swift clusters.

SwiftStack Public Controller
    Provides a public management service in public cloud that help users to deploy and 
    manage Swift clusters.

SwiftStack Nodes
    A node installed SwiftStack agents and packages, that can be managed by a 
    SwiftStack ccontroller, the node could be assigned a Swift role likes ``Swift node``
    (Proxy/Account/Container/Object services are running in a single node)


SwiftStack Fuel Plugin
======================

Allow Mirantis OpenStack environment able to use a running Swift cluster managed by 
a SwiftStack Controller. SwiftStack fuel plugin disables the default Swift cluster 
that deployed on the Controller or Primary-Controller nodes, and then reconfigures 
Swift API endpoints, Keystone and Glance settings to a running SwiftStack Swift cluster.

Requirements
------------


License
-------

==========================   ==================
Component                    License type
==========================   ==================
No components are present
==========================   ==================


Requirements
------------

+-----------------------------------+---------------------------------------------+
|Requirement                        | Version/Comment                             |
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


Installation Guide
==================

.. toctree::
    :maxdepth: 2

    install


User Guide
==========

.. toctree::
    :maxdepth: 2

    user

Known issues
============

#. Need DNS server support to map Swift APIs hostname and IP

    SwiftStack provides a software load balancer, which requries an external DNS server
    to operate. Please use DNS server insteand of static hostname records in /etc/hosts.

#. Self-signed SSL certificates are not supported in the SwiftStack plugin

    Self-signed certificates could be an issue when used in a production environment 
    because all clients need to trust the cert to pass the TLS/SSL verification.
    It is highly recommended to use certificates signed by a known, trusted Certificate 
    Authority if you require TLS/SSL for your Swift cluster endpoint.

#. Integration with `LDAP Fuel plugin`_ (You can find the validated rpm `from Mirantis`_).

    LDAP Fuel plugin can integrate your LDAP server as a Keystone Identity provider so that 
    existing users in LDAP can access Mirantis OpenStack. If you have some existing users
    which conflict with the OpenStack environment service users (i.e., swift, heat, .., etc), 
    this could cause the deployment to fail, since the SwiftStack Fuel plugin will try to 
    create Swift user for Swift service in Keystone DB. Please make sure you don't have an 
    existing user called ``Swift`` on your LDAP server. 

    For more information about setting up LDAP OUs and Groups, please see this `document`_.



.. _LDAP Fuel plugin: https://github.com/openstack/fuel-plugin-ldap 
.. _from Mirantis: https://www.mirantis.com/validated-solution-integrations/fuel-plugins/
.. _document: https://wiki.openstack.org/wiki/OpenLDAP


.. include:: appendix.rst

