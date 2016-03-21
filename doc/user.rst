User Guide
==========

SwiftStack provides **On-Premises** and **Public(Platform)** Controller to manage 
Swift clusters. Here is an overview for network topology between SwiftStack cluster, 
controller and Fuel slave nodes. 



SwiftStack Swift Cluster
------------------------

In SwiftStack Swift cluster, that have three network interfaces need to configure for each node.
 
  #. Outward-facing interface
     The clients traffic come into this interface, so if you consider putting an external 
     load balancer in front of the cluster, you should add these outward-facing IPs to the load 
     balancer pool.

  #. Cluster-facing interface
     The interface for Swift internal traffic likes proxy-server from/to object-server.

  #. Data replication interface
     This interface is dedicated for object replication.

If the node only has one network interface, you can assign all network interfaces to this 
interface, but it'll be mixed all traffic together. So we suggest using dedicated interface for 
these three network. Check `Configure network`_ to get more detail.

.. _Configure network: https://swiftstack.com/docs/admin/node_management/configure_network.html#network


SwiftStack Controller
---------------------

SwiftStack provide two types of controllers, first one is **public controller** (we called `platform controller`) 
and the second one is **On-Premises controller**. The public controller is for customers they don't want to setup
a SwiftStack Controller on their data center and also allow the nodes have internet connectivity for management
purpose. So, if you don't have an controller account yet, `try to create it`_ .

In On-Premises controller, you need to get the setup script and tarball from SwiftStack sales, and they'll help 
you to setup an on-premises controller. 

And make sure you have an account can login to controller and able to setup a swift cluster before you start 
to test the plugin, 

The network configuration in SwiftStack Controller is quite simple, just check the SwiftStack Nodes can reach 
SwiftStack controller because SwiftStack Nodes communciate with controller over OpenVPN connections. But if
you have a firewall in the middle; please check `SwiftStack Controller Security`_ and `SwiftStack Node Security`_
to configure the firewall.

.. _platform controller: https://platform.swiftstack.com
.. _try to create it: https://www.swiftstack.com/try-it-now/ 

.. _SwiftStack Controller Security: https://swiftstack.com/docs/security/controller.html#swiftstack-controller-security
.. _SwiftStack Node Security: https://swiftstack.com/docs/security/node.html#swiftstack-node-security


Fuel Slave Nodes
----------------

Fuel slave nodes have three network interfaces to configure, so if SwiftStack Nodes are connected to these 
three networks and use same IP range of `fuel's configuration`_, you need to skip the IPs that used for SwiftStack 
Nodes. The reason is the fuel master doesn't know which IP is taken from SwiftStack Nodes.

The SwiftStack Swift cluster is a standalone cluster, and each client should come from Outward-facing network.
So connected to the fuel slave nodes with Outward-facing network should be enough.

.. _fuel's configuration: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide/install/install_change_network_interface.html#configure-a-network-interface-for-the-fuel-web-ui

Network summary
---------------

Please make sure the network configuration like:

    1. Fuel controller nodes (Keystone, Glance) can talk to Swift Proxy-server (i.e., 
       Proxy-only, PAC, PACO node) for :ref:`Outward-facing IP<proxy_outward_facing_ip>`.
    2. Clients can talk to :ref:`Swift API IP Address<swift_api_ip>` (Swift Proxy or External/Internal Load Balancer)
    3. SwiftStack nodes can talk to SwiftStack Controller

    .. note::

        We only use one PACO (Proxy/Account/Comtainer/Object) nodes to deploy a all-in-one 
        Swift cluster in this document and is a minimum deployment. 
        In real environment, you might setup ten nodes or more for a Swift cluster, 
        so follow the roles can help you do integration.



Use SwiftStack On-Premises Controller
-------------------------------------

    * 1 Controller Node 
    * 1 Compute Node (have **Compute** and **Storage - Cinder** roles)
    * 1 Swift cluster
    * 1 SwiftStack On-Premises controller

    .. note::
        In this diagram, the Swift cluster is also connected to management and public network, 
        for our use case, just make sure the storage network is connected should be enough,
        Other interfaces of SwiftStack Nodes, should be used for cluster-facing and replication 
        networks.


    .. image:: images/use_on_prem.png


Use SwiftStack Public Controller (Platform)
-------------------------------------------

    * 1 Controller Node
    * 1 Compute Node (have **Compute** and **Storage - Cinder** roles)
    * 1 Swift cluster

    .. note::
        In this diagram, the Swift cluster is also connected to management and public network, 
        for our use case, just make sure the storage network is connected should be enough,
        Other interfaces of SwiftStack Nodes, should be used for cluster-facing and replication 
        networks.

    .. image:: images/use_platform.png


Deploying Mirantis OpenStack with a SwiftStack Swift cluster
------------------------------------------------------------

#. Create a new environment with two nodes:

    * Select **Liberty on Ubuntu Trusty (14.04)** as the distribution
    * Select **Neutron with VLAN segmentation** as the networking setup
    * Use all default settings
    * 1 Controller Node (has **Controller** and **Storage - Cinder** roles)
    * 1 Compute Node (has **Compute** role)

    .. image:: images/1_add_nodes.png

    .. _swift_api_ip_address:


#. Go to the Settings tab of the Fuel Web UI,
   scroll down to **Storage** section, select **Enable SwiftStack Swift Cluster Integration** checkbox
   and fill up all parameters.

    #. **Enable TLS for Swift endpoints**:

       This option will use HTTPS for swift endpoints include public, admin and internal urls.

    #. **Swift API IP Address** and **Swift API hostname**:

       The IP address is the default value for Swift endpoints, if you fill up the API hostname, that
       overwrites Swift endpoints with hostname.
    
    #. **Use Swift as Glance backend** and **Enable  upload test**:

       These two options for Glance integration
    
    .. note::
        If **Use Swift as Glance backend** is disabled,
        please consider to enable  **Ceph RBD for images (Glance)** or other storage for Glance backend.
        
        If **Enable upload test** is disabled, Fuel won't upload testVM image(cirros-testvm)
        to Glance and store in Swift cluster. That means some **Functional tests** won't pass:
        ``Create volume and boot instance from it``.

    The settings in below,

        #. Swift API IP Address: ``192.168.1.100``.
        #. Use Swift as Glance backend: ``Checked``
        #. Enable upload test: ``Checked`` 

    .. image:: images/2_enable_plugin.png

#. Go to the **Networks** tab, scroll down to **Storage** section and then
   uncheck **Use VLAN tagging** and modify **IP Range** to skip the Swift Proxy IP
   (Outwarding-facing) and Swift API IP Address.

    .. image:: images/3_config_network.png

   If you install SwiftStack node on fuel slave nodes with role ``Operating System``, 
   please also skip the IPs in Public and Managent IP ranges, because the fuel master 
   doesn't know which IP addresses used for SwiftStack nodes.

    .. _proxy_outward_facing_ip:
    .. _swift_api_ip:

    .. note::
        If you have more than one Proxy server (Proxy-only, PAC, PACO nodes),
        or you use external/internal load balancer (Swift API IP Address) for
        your swift cluster, please consider to skip these IPs.

        * ``Outtward-facing IP from SwiftStack Controller UI``

        .. image:: images/3-1_proxy_outwarding-facing.png

        * ``Swift API IP address(Load balancer IP) from SwiftStack Controller UI``

        .. image:: images/3-2_swift_api_ip.png


#. Go to the **Nodes** tab of the Fuel Web UI,
   drag **Storage** interface to **eth2** for all nodes:

    .. image:: images/4_config_interfaces.png

   .. _find_keystone_password:

#. Find the settings from deployment information:
    * Keystone IP Address (management_vip)
    * Swift password

    Please login to the fuel master and create a script file called **swiftstack.sh** 
    with contents in below,

    .. code-block:: bash

        #!/bin/bash
        cd /root 
        fuel env 
        echo -e "\n\n" 
        read -p "Which environment?" environment 

        # Export environment  
        fuel deployment --env $environment --default 
        
        # put error checking here 
        SwiftIP=$(sed -e '/vips:/,/ipaddr:/!d' \
                  deployment_*/primary-controller*.yaml \
                  | grep ipaddr | awk '{print $2}')
        SwiftPW=$(sed -e '/swift:/,/user_password:/!d' \
                  deployment_*/primary-controller*.yaml \
                  | grep user_password| awk '{print $2}')

        echo "Configure Keystone Auth Token Support middleware with the parameters below :" 
        echo "----------------------------------------------------------------------------" 
        echo "  identity URL      : http://$SwiftIP:35357/"  
        echo "  auth_url          : http://$SwiftIP:5000/" 
        echo "  admin_user        : swift" 
        echo "  admin_password    : $SwiftPW" 

    Change permissions and run it.

    .. code-block:: bash

        [root@fuel ~]$ chmod +x swiftstack.sh
        [root@fuel ~]$ ./swiftstack.sh

        id | status | name    | release_id | pending_release_id
        ---|--------|---------|------------|-------------------
        5  | new    | MOS 8.0 | 2          | None


        Which environment?5
        Default deployment info was downloaded to /root/deployment_5
        Configure Keystone Auth Token Support middleware with the parameters below :
        ----------------------------------------------------------------------------
          identity URL      : http://192.168.0.2:35357/
          auth_url          : http://192.168.0.2:5000/
          admin_user        : swift
          admin_password    : Ym35Y7j43K6LgsY9xYkJ5TbW

   .. _setup_swift_middleware:

#. Once we get Keystone IP (192.168.0.2) and Swift user’s password (``Ym35Y7j43K6LgsY9xYkJ5TbW``), \
   let’s login to SwiftStack Controller UI to configure Swift cluster
 
    * Go to the **Middleware** tab, enable and configure **Keystone Auth Token Support** middleware as below:

        .. code-block:: bash

            identity_url:      http://192.168.0.2:35357/
            auth_url:          http://192.168.0.2:5000/
            admin_user:        swift
            admin_password:    Ym35Y7j43K6LgsY9xYkJ5TbW
            admin_tenant_name: services


        .. image:: images/5_config_key1.png

    * Enable and configure **Keystone Auth** middleware as below:

        .. code-block:: bash

            reseller_admin_role: admin


        .. image:: images/6_config_key2.png


#. Push configure settings to SwiftStack Swift cluster.

#. Get back to the Fuel Web UI and deploy your OpenStack environment.

#. Once Mirantis OpenStack environment is done, you will see the SwiftStack plugin is also deployed.

.. image:: images/7_deploy_verify1.png

Verification
++++++++++++

Please run the verification steps below to ensure your Swiftstack plugin is configured properly:

#. Check API endpoints from OpenStack Dashboard:

  .. image:: images/8_deploy_verify2.png

  
.. _verity_cluster_swift_cli:

#. Verify Swift cluster, Keystone and Glance integration through Swift cli

  * Check admin account

  .. code-block:: bash

    # Login to one of nodes of Swift cluster. 

    # Test admin account
    ~$ cat rc.admin 
    export ST_AUTH=http://192.168.0.2:5000/v2.0
    export ST_USER=admin:admin
    export ST_KEY=admin
    export ST_AUTH_VERSION=2

    ~$ source rc.admin 
    ~$ swift stat -v
                                 StorageURL: http://192.168.1.100:80/v1/KEY_c59857e
                                             9f07a44e691e1a12d3ef71d59
                                 Auth Token: gAAAAABW77vTlydZxpTB0yiRimVlTorg6IC9GR
                                             lB5moChyd-P6NlsQ_rJva114IecQxxHB4YR5cd
                                             RECCY4VQZnDSP9wgneG-xSi6P4XKwLDmX9lQKb
                                             YGpCb1l19JyiuBdRZyoc3JC0uiFtW6YfQ0mvPp
                                             VOEWgQJ02tL-vBqfFNcuiiWthn20Rok
                                    Account: KEY_c59857e9f07a44e691e1a12d3ef71d59
                                 Containers: 0
                                    Objects: 0
                                      Bytes: 0
    Containers in policy "standard-replica": 0
       Objects in policy "standard-replica": 0
         Bytes in policy "standard-replica": 0
                              Accept-Ranges: bytes
                X-Account-Project-Domain-Id: default
                                X-Timestamp: 1458550300.21393
                                 X-Trans-Id: tx1d579f93ee7846fab0eaa-0056efbbd3
                               Content-Type: text/plain; charset=utf-8



  * Check glance account when **Use Swift as Glance backend** is enabled

  .. code-block:: bash

    # Find glance password from deployment yaml
    [root@fuel ~]$ sed -e '/glance:/,/user_password:/!d' \
                          deployment_*/primary-controller*.yaml
       glance:
         db_password: XkyxjTF4LKu7FgaY2YyXlUMI
           image_cache_max_size: '13928339865'
             user_password: ZHFGFM7ivEi0XPuL7l4tt5jE



    # Test glance account
    ~$ cat rc.glance 
    export ST_AUTH=http://192.168.0.2:5000/v2.0
    export ST_USER=services:glance
    export ST_KEY=ZHFGFM7ivEi0XPuL7l4tt5jE
    export ST_AUTH_VERSION=2

    ~$ swift stat -v
                              StorageURL: http://192.168.1.100:80/v1/KEY_fc5bc05137
                                          09448da632c525728cf79
                              Auth Token: gAAAAABW77t5VpWr7tzqAtOhYhWiQOo11kqeoSS_0
                                          mnX1WgNprVkAl5Sj8Ut0DuHYnBcg7UdwH00OHfotq
                                          sS9PmetqQSP-RTuQwmwVLH8JAHtpZLm5CFa0ocIJj
                                          o35oFavevzrjsokY4MefxyNlIhByshPelV6Dp3RD0
                                          C9aBygH96gedpOEUw
                                    Account: KEY_fc5bc0513709448da632c525728cf794
                                 Containers: 1
                                    Objects: 1
                                      Bytes: 13287936
    Containers in policy "standard-replica": 1
       Objects in policy "standard-replica": 1
         Bytes in policy "standard-replica": 13287936
                              Accept-Ranges: bytes
                X-Account-Project-Domain-Id: default
                                X-Timestamp: 1458547227.84808
                                 X-Trans-Id: txac14e38486ea45c98bc6d-0056efbb8d
                               Content-Type: text/plain; charset=utf-8




Appendix
--------

    * SwiftStack docs can be found at https://swiftstack.com/docs/


