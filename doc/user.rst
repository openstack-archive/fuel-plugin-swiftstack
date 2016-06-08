User Guide
==========

SwiftStack provides **On-Premises** and **Public(Platform)** Controller to manage 
Swift clusters. Here is an overview for network topology between SwiftStack cluster, 
controller and Fuel slave nodes. 



SwiftStack Swift Cluster
------------------------

In SwiftStack Swift cluster, that have three network interfaces need to configure for each node.
 
  #. Outward-facing interface:

     The clients traffic come into this interface, so if you consider putting an external 
     load balancer in front of the cluster, you should add these outward-facing IPs to the load 
     balancer pool.

  #. Cluster-facing interface:

     The interface for Swift internal traffic likes proxy-server from/to object-server.

  #. Data replication interface:

     This interface is dedicated for object replication.

If the node only has one network interface, you can assign all network interfaces to this 
interface, but it'll be mixed all traffic together. So we suggest using dedicated interface for 
these three network. Check `Configure network`_ to get more detail.

.. _Configure network: https://swiftstack.com/docs/admin/node_management/configure_network.html#network


SwiftStack Controller
---------------------

SwiftStack provide two types of controllers, first one is **public controller** (we called `Platform controller`) 
and the second one is **On-Premises controller**. The public controller is for customers they don't want to setup
a SwiftStack Controller on their data center and also allow the nodes have internet connectivity for management
purpose. So, if you don't have an controller account yet, `try to create it`_ .

In On-Premises controller, you need to get the setup script and tarball from SwiftStack sales, and they'll help 
you to setup an On-Premises controller. 

And make sure you have an account can login to controller and able to setup a Swift cluster before you start 
to test the plugin.

The network configuration in SwiftStack Controller is quite simple, just check the SwiftStack Nodes can reach 
SwiftStack controller because SwiftStack Nodes communciate with controller over OpenVPN connections. But if
you have a firewall in the middle; please check `SwiftStack Controller Security`_ and `SwiftStack Node Security`_
to configure the firewall.

    .. note::
        There is no difference when you use On-Premises or Platform controller to create you own Swift cluster,
        and do the integration with SwiftStack Fuel plugin. All configuration of SwiftStack Fuel plugin will 
        be the same. 

        The Swift cluster is outside of Fuel environment, so using the Controller to create and configure your 
        external Swift cluster which will be more efficienct from scratch.

.. _Platform controller: https://platform.swiftstack.com
.. _try to create it: https://www.swiftstack.com/try-it-now/ 

.. _SwiftStack Controller Security: https://swiftstack.com/docs/security/controller.html#swiftstack-controller-security
.. _SwiftStack Node Security: https://swiftstack.com/docs/security/node.html#swiftstack-node-security


Fuel Slave Nodes
----------------

Fuel slave nodes have three major networks(public, storage, management) to configure, so if SwiftStack Nodes are 
connected to these three networks and use same IP range of `Fuel's configuration`_, you need to skip the IPs that 
used for SwiftStack Nodes. The reason is the Fuel master doesn't know which IP is taken from SwiftStack Nodes.

The SwiftStack Swift cluster is a standalone cluster, and each client should come from Outward-facing network
(Fuel Public Network).  So connected to the Fuel slave nodes with Outward-facing network that's for clients. 
Then Fuel Managment network will use for doing user token validation between the Swift cluster and Keystone 
server. The SwiftStack cluster-facing and data replication network should be over Fuel Storage network. 

.. _Fuel's configuration: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide/install/install_change_network_interface.html#configure-a-network-interface-for-the-fuel-web-ui

Network summary
---------------

Please make sure the network configuration like:

    #. Fuel controller nodes (Keystone, Glance) can talk to Swift Proxy-server (i.e., 
       Proxy-only, PAC, PACO node) over Fuel Management network
    
    #. Clients can talk to :ref:`Swift API IP Address<swift_api_ip>` (Swift Proxy or 
       External/Internal Load Balancer)

    #. SwiftStack nodes can optionally talk to each over Fuel Storage network

    #. SwiftStack nodes can talk to SwiftStack Controller via Management (SwiftStack) 
       network (for On-Premises) or Public network (for public Swiftstack Controller)

    .. note::

        We only use one PACO (Proxy/Account/Comtainer/Object) nodes to deploy a all-in-one 
        Swift cluster in this document and is a minimum deployment. 
        In real environment, as the cluster scales, it might be necessary to specalize nodes
        into separate Proxy/Account/Container/Object tiers.
        If the Fuel Storage network does not have adequate bandwidth to support Replication &
        Cluster-Facing traffic, these interfaces can be on a network external to Fuel


Use SwiftStack On-Premises Controller
-------------------------------------

Please setup an On-Premises SwiftStack controller first, and then setup a single node Swift 
cluster with SwiftStack controller, here is our `quick start guide`_.

    * 1 SwiftStack On-Premises controller
    * 1 Swift cluster (single node)

Also prepare a Fuel environment using Slave nodes according to the `Fuel Install Guide`_.

    .. note::
        In this diagram, the Swift cluster is also connected to Fuel Storage network for SwiftStack 
        cluster-facing and data replication network, if you have performance concern, please consider 
        to separate Swift cluster-facing and data replication network out of Fuel networks.
        That prevents network starvation on Fuel Storage network when Swift service daemons are 
        moving data or clients upload large data into the Swift cluster. 

        Also, SwiftStack Nodes need to communicate with the On-Premises controller over Fuel 
        Management network, so please make sure the On-Premises controller alos connected to Fuel Management
        network. You can run a CLI command ``ssdiag`` on SwiftStack nodes to check the connectivity 
        between SwiftStack Nodes and Controller.

    .. image:: images/use_on_prem.png



Use SwiftStack Public Controller (Platform)
-------------------------------------------

Please setup a single node Swift cluster with our public controller, here is our `quick start guide`_.

    * 1 Swift cluster (single node)

Also prepare a Fuel environment using Slave nodes according to the `Fuel Install Guide`_.


    .. note::
        In this diagram, the Swift cluster is also connected to Fuel Storage network for SwiftStack 
        cluster-facing and data replication network, if you have performance concern, please consider 
        to separate Swift cluster-facing and data replication network out of Fuel networks.
        That prevents network starvation on Fuel Storage network when Swift service daemons are 
        moving data or clients upload large data into the Swift cluster. 

        Also, SwiftStack Nodes need to communicate with SwiftStack Public controller over Fuel 
        Public network, so please make sure SwiftStack Nodes able to reach Internet.

    .. image:: images/use_platform.png


.. _quick start guide: https://swiftstack.com/docs/install/index.html
.. _Fuel Install Guide: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide.html


Deploying Mirantis OpenStack with a SwiftStack Swift cluster
------------------------------------------------------------

#. Create a new environment with available Slave nodes:

    * Select **Liberty on Ubuntu Trusty (14.04)** as the distribution
    * Select **Neutron with VLAN segmentation** as the networking setup
    * Use all default settings
    * Select node roles according to the `Fuel Install Guide`_.

    .. image:: images/1_add_nodes.png

    .. _swift_api_ip_address:

.. _Fuel Install Guide: http://docs.openstack.org/developer/fuel-docs/userdocs/fuel-install-guide.html


#. Go to the Settings tab of the Fuel Web UI,
   scroll down to **Storage** section, select **Enable SwiftStack Swift Cluster Integration** checkbox
   and fill up all parameters.

    #. **Enable TLS for Swift endpoints**:

       This option will use HTTPS for Swift endpoints include public, admin and internal urls.

    #. **Swift API IP Address** and **Swift API hostname**:

       The IP address is the default value for Swift endpoints, if you fill up the API hostname, that
       overwrites Swift endpoints with hostname.
    
    #. **Use Swift as Glance backend** and **Enable  upload test**:

       These two options for Glance integration
    
    .. note::
        If **Use Swift as Glance backend** is disabled,
        please consider enabling  **Ceph RBD for images (Glance)** or other storage for Glance backend.
        
        If **Enable upload test** is disabled, Fuel won't upload testVM image(cirros-testvm)
        to Glance and store in Swift cluster. That means some **Functional tests** won't pass:
        ``Create volume and boot instance from it``.

    The settings in below,

        #. Swift API IP Address: ``172.16.0.100``.
        #. Use Swift as Glance backend: ``Checked``
        #. Enable upload test: ``Checked`` 

    .. image:: images/2_enable_plugin.png

#. Go to the **Networks** tab, scroll down to **Public** section and then
   modify **IP Range** to skip the IPs of SwiftStack Outward-facing and 
   Swift API IP Address.

   Here is our network configuration for a single SwiftStack node.

    .. image:: images/3_config_network_swift_cluster.png

   Skip `172.16.0.100` (Outward-facing) on Public network.

    .. image:: images/3_config_network.png
    
   Also, skip the IPs of SwiftStack Cluster-facing and data replication in **IP Range** of
   **Storage** section, so skip `192.168.1.100` (Cluster-facing/data replication) on Storage 
   network

    .. image:: images/3_config_network_storage.png

   If you use SwiftStack On-Premises Controller, you need to do same thing in **Management** 
   section to skip the IPs of SwiftStack nodes and On-Premises Contorller.

    .. image:: images/3_config_network_mgmt.png

    .. _proxy_outward_facing_ip:
    .. _swift_api_ip:

    .. note::
        If you have more than one Proxy server (Proxy-only, PAC, PACO nodes),
        or you use external/internal load balancer (Swift API IP Address) for
        your Swift cluster, please consider to skip these IPs.

        * ``Outtward-facing IP from SwiftStack Controller UI``

        .. image:: images/3-1_proxy_outward-facing.png

        * ``Swift API IP address(Load balancer IP) from SwiftStack Controller UI``

        .. image:: images/3-2_swift_api_ip.png


#. Go to the **Nodes** tab of the Fuel Web UI,
   drag **Storage** interface to **eth2** and untagged the VLAN for all nodes:

    .. image:: images/4_config_interfaces.png

    .. note::
        The management network is tagged with VLAN ID 101 by default, so you also need
        to configure VLAN ID for interfaces of SwiftStack Nodes and On-Premises Controller

   .. _find_keystone_password:

#. Find the settings from deployment information:
    * Keystone IP Address (management_vip)
    * Swift password

    Please login to the Fuel master and create a script file called **swiftstack.sh** 
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
        SwiftIP=$(sed -e '/  management:/,/ipaddr:/!d' \
                  deployment_*/primary-controller*.yaml \
                  | grep ipaddr | awk '{print $2}')
        SwiftPW=$(sed -e '/swift:/,/user_password:/!d' \
                  deployment_*/primary-controller*.yaml \
                  | grep user_password| awk '{print $2}')

        echo "Configure Keystone Auth Token Support middleware with the parameters below :" 
        echo "----------------------------------------------------------------------------" 
        echo "  identity_url      : http://$SwiftIP:35357/"  
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
          identity_url      : http://192.168.0.2:35357/
          auth_url          : http://192.168.0.2:5000/
          admin_user        : swift
          admin_password    : v4LiGbh6xPU0vtqXQSMeDjxc

   .. _setup_swift_middleware:

#. Once we get Keystone IP (192.168.0.2) and Swift user’s password (``v4LiGbh6xPU0vtqXQSMeDjxc``), \
   let’s login to SwiftStack Controller UI to configure Swift cluster
 
    * Go to the **Middleware** tab, enable and configure **Keystone Auth Token Support** middleware as below:

        .. code-block:: bash

            identity_url:      http://192.168.0.2:35357/
            auth_url:          http://192.168.0.2:5000/
            admin_user:        swift
            admin_password:    v4LiGbh6xPU0vtqXQSMeDjxc
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

Please run the verification steps below to ensure your SwiftStack plugin is configured properly:

#. Check API endpoints with Keystone CLI:

  .. code-block:: bash

      root@node-23:~# source ~/openrc 

      ##
      ## Make sure the keystone VIP is correct
      ##
      root@node-23:~# export OS_AUTH_URL='http://192.168.0.2:5000/v2.0'

      root@node-23:~# keystone endpoint-list |grep KEY
      | b858f41ee3704f32a05060932492943b | RegionOne 
      | http://172.16.0.100:80/v1/KEY_%(tenant_id)s 
      | http://172.16.0.100:80/v1/KEY_%(tenant_id)s 
      | http://172.16.0.100:80/v1/KEY_%(tenant_id)s 
      | 19966ec76f0d455d94caa87d9569a347 |

  
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
                   StorageURL: http://172.16.0.100:80/v1/KEY_9f12acc2fc1c4b4cb
                               75916b2724e2903
                   Auth Token: gAAAAABXV5CFn_cx-Y2pJK4de7XDDXvEmfo4SlhmCAAOweG
                               -RHLkSCCqfc_mGHoJ-7ee4cACSzzx5bXijCtopbRA-Mh2vr
                               _SGK9GKSB1AIt-Q1kSsUJTNgjL0T6Hws66r7gh4PmiTFwhO
                               uhV9BTswzF9GzIHdUpKusd3jhrclcc9ipQdnF_bF1c
                      Account: KEY_9f12acc2fc1c4b4cb75916b2724e2903
                   Containers: 0
                      Objects: 0
                        Bytes: 0
              X-Put-Timestamp: 1465356423.33437
                  X-Timestamp: 1465356423.33437
                   X-Trans-Id: txf07064e2471544b29f84d-0057579086
                 Content-Type: text/plain; charset=utf-8

  * Check glance account when **Use Swift as Glance backend** is enabled

  .. code-block:: bash

    # Find glance password from deployment yaml
    [root@fuel ~]$ sed -e '/glance:/,/user_password:/!d' \
                          deployment_*/primary-controller*.yaml
       glance:
         db_password: XkyxjTF4LKu7FgaY2YyXlUMI
           image_cache_max_size: '13928339865'
             user_password: iqxWViMcHUjxbWD0hqkvjbon



    # Test glance account
    ~$ cat rc.glance 
    export ST_AUTH=http://192.168.0.2:5000/v2.0
    export ST_USER=services:glance
    export ST_KEY=iqxWViMcHUjxbWD0hqkvjbon
    export ST_AUTH_VERSION=2

    ~$ swift stat -v
                                     StorageURL: http://172.16.0.100:80/v1/KEY_63bda2
                                                 0adcb24e2eb37d2dcb13d2a29b
                                     Auth Token: gAAAAABXV4-d_FKAboXyxKOoWVdmbiDCLtgX
                                                 0diSqMed9gzXTPHkt5ko7AMffp28iKBX984g
                                                 KXqUKk82pjqQ9tpSIu-TA9cTLoZYz0Cabp9Y
                                                 s-zIH-BJOP1DZsEaOIOB8wTrvU2i_eGyPKgN
                                                 25iaARIahh2MYUkNU21Xfzg7Q7bQlwvFFhMo
                                                 d7g
                                        Account: KEY_63bda20adcb24e2eb37d2dcb13d2a29b
                                     Containers: 1
                                        Objects: 1
                                          Bytes: 13287936
        Containers in policy "standard-replica": 1
           Objects in policy "standard-replica": 1
             Bytes in policy "standard-replica": 13287936
                                  Accept-Ranges: bytes
                    X-Account-Project-Domain-Id: default
                                    X-Timestamp: 1465322384.96195
                                     X-Trans-Id: txa59a5b16d6724fc68adb7-0057578f9e
                                   Content-Type: text/plain; charset=utf-8


Appendix
--------

    * SwiftStack docs can be found at https://swiftstack.com/docs/


