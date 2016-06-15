Test Report for SwiftStack Fuel Plugin
======================================

Revision history
================

.. tabularcolumns:: |p{1.5cm}|p{2.5cm}|p{6cm}|p{5.6cm}|

.. list-table::
   :header-rows: 1

   * - Version
     - Revision Date
     - Editor
     - Comment
   * - 1.0
     - 27.08.2015
     - Charles Hsu(chsu@swiftstack.com)
     - Created
   * - 2.0
     - 06.07.2016
     - Charles Hsu(chsu@swiftstack.com)
     - Revised for Fuel 8.0
   * - 2.1
     - 06.15.2016
     - Charles Hsu(chsu@swiftstack.com)
     - Update contents and rewrite in RST
   * -
     -
     -
     -

Document purpose
================

This document provides test run results for Integration testing of SwiftStack
Fuel Plugin 0.3.0 on Mirantis OpenStack 8.0.

Test environment
================

The following is the hardware configuration for target nodes used for
verification. For other configuration settings, please see the test plan.

 * Mirantis OpenStack: 8.0
 * Plugin release version: 0.3.0
 * Lab environment: 
    * 4 nodes (3 controllers and 1 compute nodes) or more
    * 1 SwiftStack Swift cluster

Plugin's RPM 
------------

.. tabularcolumns:: |p{8cm}|p{7.6cm}|

.. list-table::
   :header-rows: 1


   * - Name
     - md5 checksum
   * - swiftstack-0.3-0.3.0-1.noarch.rpm   
     - 7116620d039d9b93731aa38ababe48fa


Test coverage and metrics
-------------------------
    
 * Test Coverage – 100%
 * Tests Passed – 100%
 * Tests Failed – 0%

Test results summary
====================

SwiftStack plugin is an integration plugin, so we run  
 
* System testing
  
  * Manuel Test (8)


Type of testing
===============

Coverage of features
--------------------

.. tabularcolumns:: |p{12cm}|p{3.6cm}|

.. list-table::
   :header-rows: 1

   * - Parameter
     - Value
   * - Total quantity of executed test cases
     - 8
   * - Total quantity of not executed test cases
     - 0
   * - Quantity of automated test cases
     - 0
   * - Quantity of not automated test cases
     - 8

Detailed test run results
-------------------------

.. tabularcolumns:: |p{1cm}|p{7cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{3cm}|

.. list-table::
   :header-rows: 1

   * - #
     - Test case ID
     - Passed
     - Failed
     - Skipped
     - Comment
   * - 1
     - install_plugin_deploy_env
     - yes
     -
     -
     -
   * - 2
     - install_plugin_deploy_env_with_swift_hostname
     - yes
     -
     -
     -
   * - 3
     - modify_env_with_plugin_remove_add_controller
     - yes
     -
     -
     -
   * - 4
     - modify_env_with_plugin_remove_add_compute
     - yes
     -
     -
     -
   * - 5
     - Fuel_create_mirror_update_core_repos
     - yes
     -
     -
     -
   * - 6
     - uninstall_plugin_with_deployed_env
     - yes
     -
     -
     -
   * - 7
     - uninstall_plugin
     - yes
     -
     -
     -
   * - 8
     - apply_mu
     - yes
     -
     -
     -
   * -
     -
     -
     -
     -
     -
   * - Total
     -
     - 8
     -
     -
     -
   * - Total, %
     -
     - 100%
     -
     -
     -

Known issues
============

.. list-table::
   :header-rows: 1

   * - #
     - Description
     - Severity    
     - Status
   * -
     -
     -
     -


Logs
====

.. list-table::
   :header-rows: 1

   * - #
     - Title
   * -
     -

Appendix
========

.. list-table::
   :header-rows: 1

   * - #
     - Title of resource
   * -
     -


