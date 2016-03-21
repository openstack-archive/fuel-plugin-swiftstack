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

   SwiftStack provide a software load balancer, it requries DNS support. Please
   use DNS server insteand of static hostname records in /etc/hosts.

#. Self-certification for SwiftStack plugin don't support

   Self-certification could be an issue, when use it on production environment.
   Because all clients need to add the cert to pass the TLS/SSL verification.
   So we suggest to use third-party certification if you requrie to enable TLS/SSL 
   for your Swift cluster endpoint.

Appendix
========

#. SwiftStack docs can be found at https://swiftstack.com/docs/



