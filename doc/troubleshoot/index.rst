Troubleshooting Guide
=====================


Source file (~/openrc) 
----------------------
If you try run swift cli in controller nodes, please check OS_AUTH_URL is correct. If the value is ``http://<KEYSTONE_VIP>:5000/``, please correct it to ``http://<KEYSTONE_IP>:5000/v2.0`` as following.

    .. code-block:: python

        root@node-17:~# cat openrc 
        #!/bin/sh
        ...
        export OS_AUTH_URL='http://<KEYSTONE_VIP>:5000/v2.0'
        ...



External Load Balancer
----------------------

If there is a external load balancer in front of you Swift cluster, and you confgiure the swift cluster with it. Please fill the external LB IP for ``Swift API IP Address`` in :ref:`plugin page <swift_api_ip_address>`.


Swift endpoint in Keystone DB
-----------------------------

Before you upload any VM image to Glance, we suggest to check the Swift endpoint in Keystone DB first. Make sure the Swift endpoint is correct.

For swift endpoint, please make sure the endpoints (``publicurl`` and ``internalurl``) look like ``http://<SWIFT_API_IP>:80/v1/KEY_%(tenant_id)s``.

    .. code-block:: python

        $ openstack endpoint list | grep swift 


401 Unauthorized issue from clients
-----------------------------------

If any client runs into ``401 Unauthorized`` issue, please use Swift CLI verify it again and make sure the settings of middlewares in Swift cluster are correct. 

For example, if you get a error with ``swift stat``.

    .. code-block:: python

        $ swift stat
        Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324fb6aea 401 Unauthorized

Try to use ``--debug`` to get more detail.

    .. code-block:: python

        $ swift --debug stat -v
        ..<SKIP>..
        INFO:requests.packages.urllib3.connectionpool:Starting new HTTP connection (1): 10.200.5.5
        DEBUG:requests.packages.urllib3.connectionpool:"HEAD /v1/KEY_32f0b6cd7299412e9f7966b324fb6aea HTTP/1.1" 401 0
        INFO:swiftclient:REQ: curl -i http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324fb6aea -I -H "X-Auth-Token: gAAAAABXMe1s87mzqZK1Ee8hyJQ86fv9NDcSChKCLk-PTQfa353J5t3N4EL-OCHbZuqt6hRFBJehUozgF4FNNd5Q_rfXBejo817U_Ff6mAy6-hP2l0KWbxON1mfZL_UCfjjWclrSD2-bK38JvTfrqWdM99cqfdMBDZS-wqHn1dZzO0g2r-Kzxcc"
        INFO:swiftclient:RESP STATUS: 401 Unauthorized
        INFO:swiftclient:RESP HEADERS: [('Content-Length', '0'), ('Connection', 'keep-alive'), ('X-Trans-Id', 'txecd82ae98e714ef0b4c0c-005731ed6c'), ('Date', 'Tue, 10 May 2016 14:17:16 GMT'), ('Content-Type', 'text/html; charset=UTF-8'), ('Www-Authenticate', 'Swift realm="KEY_32f0b6cd7299412e9f7966b324fb6aea", Keystone uri=\'http://10.200.7.2:5000/\'')]
        ERROR:swiftclient:Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324fb6aea 401 Unauthorized
        Traceback (most recent call last):
          File "/usr/lib/pymodules/python2.7/swiftclient/client.py", line 1261, in _retry
            rv = func(self.url, self.token, *args, **kwargs)
          File "/usr/lib/pymodules/python2.7/swiftclient/client.py", line 541, in head_account
            http_response_content=body)
        ClientException: Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324fb6aea 401 Unauthorized
        Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324fb6aea 401 Unauthorized



If the keystone IP and Swift user and password are correct, please :ref:`find the password from deployment yaml files<find_keystone_password>` and :ref:`config Swift middlewares <setup_swift_middleware>` first. Once that're done, please :ref:`verity it with Swift CLI<verity_cluster_swift_cli>`.


