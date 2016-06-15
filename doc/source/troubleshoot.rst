Troubleshooting Guide
=====================


Source file (~/openrc) 
----------------------
If you try run swift cli in controller nodes, please check OS_AUTH_URL is correct.
If the value is ``http://<KEYSTONE_VIP>:5000/``, please correct it to ``http://<KEYSTONE_IP>:5000/v2.0`` as following.

    .. code-block:: python

        root@node-17:~# cat openrc 
        #!/bin/sh
        ...
        export OS_AUTH_URL='http://<KEYSTONE_VIP>:5000/v2.0'
        ...



External Load Balancer
----------------------

If there is a external load balancer in front of you Swift cluster, and you confgiure the swift cluster with it.
Please fill the external LB IP for ``Swift API IP Address`` in :ref:`plugin page <swift_api_ip_address>`.


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
        Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b324
        fb6aea
        401 Unauthorized

Try to use ``--debug`` to get more details.

    .. code-block:: python

        $ swift --debug stat -v
        ..<SKIP>..
        INFO:requests.packages.urllib3.connectionpool:Starting new HTTP connection
            (1): 10.200.5.5
        DEBUG:requests.packages.urllib3.connectionpool:"HEAD /v1/KEY_32f0b6cd72994
            12e9f7966b324fb6aea HTTP/1.1" 401 0
        INFO:swiftclient:REQ: curl -i http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e
            9f7966b324fb6aea -I -H "X-Auth-Token: gAAAAABXMe1s87mzqZK1Ee8hyJQ86fv9
            NDcSChKCLk-PTQfa353J5t3N4EL-OCHbZuqt6hRFBJehUozgF4FNNd5Q_rfXBejo817U_F
            f6mAy6-hP2l0KWbxON1mfZL_UCfjjWclrSD2-bK38JvTfrqWdM99cqfdMBDZS-wqHn1dZz
            O0g2r-Kzxcc"
        INFO:swiftclient:RESP STATUS: 401 Unauthorized
        INFO:swiftclient:RESP HEADERS: [('Content-Length', '0'), ('Connection',
            'keep-alive'), ('X-Trans-Id', 'txecd82ae98e714ef0b4c0c-005731ed6c') ,
            ('Date', 'Tue, 10 May 2016 14:17:16 GMT'), ('Content-Type', 'text/htm
            l; charset=UTF-8'), ('Www-Authenticate', 'Swift realm="KEY_32f0b6cd72
            99412e9f7966b324fb6aea", Keystone uri=\'http://10.200.7.2:5000/\'')]
        ERROR:swiftclient:Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6c
            d7299412e9f7966b324fb6aea 401 Unauthorized
        Traceback (most recent call last):
          File "/usr/lib/pymodules/python2.7/swiftclient/client.py", line 1261,
          in _retry
            rv = func(self.url, self.token, *args, **kwargs)
          File "/usr/lib/pymodules/python2.7/swiftclient/client.py", line 541, 
          in head_account
            http_response_content=body)
        ClientException: Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd
             7299412e9f7966b324fb6aea 401 Unauthorized
        Account HEAD failed: http://10.200.5.5:80/v1/KEY_32f0b6cd7299412e9f7966b32
            4fb6aea 401 Unauthorized



If the keystone IP and Swift user and password are correct, please :ref:`find the password
from deployment yaml files<find_keystone_password>`
and :ref:`config Swift middlewares <setup_swift_middleware>` first. Once that're done,
please :ref:`verify it with Swift CLI<verity_cluster_swift_cli>`.


403 Forbidden issue from clients through S3 APIs
------------------------------------------------

When you saw clients get 403 response from S3 APIs, please check **Swift3 Keystone Integration Middleware**
first and make sure auth_url is point to keystone amdinurl.

    .. code-block:: bash

        ~$ ./s3get.sh test http://172.16.0.100:80 \
        >                            e8f3617f41d34d02a7ba129f8581a3b6 \
        >                            85f2ae90a9614a8b832747af3c6e6c9b \
        >                            test rc.admin
        Wed, 15 Jun 2016 14:15:14 UTC
        /test/rc.admin
        * Hostname was NOT found in DNS cache
        *   Trying 172.16.0.100...
        * Connected to 172.16.0.100 (172.16.0.100) port 80 (#0)
        > GET /test/rc.admin HTTP/1.1
        > User-Agent: curl/7.35.0
        > Host: 172.16.0.100
        > Accept: */*
        > Date: Wed, 15 Jun 2016 14:15:14 UTC
        > Authorization: AWS e8f3617f41d34d02a7ba129f8581a3b6:RG6hF77QUN/fmMMLSFP5SauMD7Q=
        > 
        < HTTP/1.1 403 Forbidden
        HTTP/1.1 403 Forbidden
        < x-amz-id-2: tx6359093a27f642db8a398-00576162f3
        x-amz-id-2: tx6359093a27f642db8a398-00576162f3
        < x-amz-request-id: tx6359093a27f642db8a398-00576162f3
        x-amz-request-id: tx6359093a27f642db8a398-00576162f3
        < Content-Type: application/xml
        Content-Type: application/xml
        < X-Trans-Id: tx6359093a27f642db8a398-00576162f3
        X-Trans-Id: tx6359093a27f642db8a398-00576162f3
        < Date: Wed, 15 Jun 2016 14:15:15 GMT
        Date: Wed, 15 Jun 2016 14:15:15 GMT
        < Transfer-Encoding: chunked
        Transfer-Encoding: chunked

And if that is still can't solve the problem or you see other error codes 
(500 Internal server error, etc.) from S3 APIs, please try to check the 
swift logs (/var/log/swift/all.log) to see is any exception on that. And you 
will have a ``X-Trams-Id`` for each request, so please use that to grep Swift 
logs likes,

    .. code-block:: bash

        # Please login to SwiftStack Nodes
        $ grep tx6359093a27f642db8a398-00576162f3 /var/log/swift/all.log

And send the output to `SwiftStack Support`_.

.. _SwiftStack Support: https://swiftstack.zendesk.com/
