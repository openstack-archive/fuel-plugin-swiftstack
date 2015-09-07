
class sscluster (
    $deployment_mode,
    $keystone_vip,
    $api_address,
    $swift_user = 'swift',
    $swift_password = 'PASSWORD',
    $glance_user = 'glance',
    $glance_password = 'PASSWORD',
    $tenant = 'services',
    $role = 'controller',
)
{
    case $::osfamily {
        'Debian':{
            $glance_api                 = 'glance-api'
            $swift_proxy                = 'swift-proxy'
            $swift_object               = 'swift-object'
            $swift_object_auditor       = 'swift-object-auditor'
            $swift_object_replicator    = 'swift-object-replicator'
            $swift_container            = 'swift-container'
            $swift_container_auditor    = 'swift-container-auditor'
            $swift_container_replicator = 'swift-container-replicator'
            $swift_container_updater    = 'swift-container-updater'
            $swift_container_sync       = 'swift-container-sync'
            $swift_account              = 'swift-account'
            $swift_account_auditor      = 'swift-account-auditor'
            $swift_account_replicator   = 'swift-account-replicator'
            $swift_account_reaper       = 'swift-account-reaper'
        }
        'RedHat':{
            $glance_api                 = 'openstack-glance-api'
            $swift_proxy                = 'openstack-swift-proxy'
            $swift_object               = 'openstack-swift-object'
            $swift_object_auditor       = 'openstack-swift-object-auditor'
            $swift_object_replicator    = 'openstack-swift-object-replicator'
            $swift_container            = 'openstack-swift-container'
            $swift_container_auditor    = 'openstack-swift-container-auditor'
            $swift_container_replicator = 'openstack-swift-container-replicator'
            $swift_container_updater    = 'openstack-swift-container-updater'
            $swift_container_sync       = 'openstack-swift-container-sync'
            $swift_account              = 'openstack-swift-account'
            $swift_account_auditor      = 'openstack-swift-account-auditor'
            $swift_account_replicator   = 'openstack-swift-account-replicator'
            $swift_account_reaper       = 'openstack-swift-account-reaper'
        }
        default: {
            fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} only support osfamily RedHat and Debian")
        }
    }

    notice("Stop Glance API Service")
    exec { 'Stop glance-api':
    	command => "service $glance_api stop",
        path => ['/usr/bin', '/sbin', '/bin'],
    }

    notice("Switch Glance backend to Swift Cluster: ${api_address}")
    class {'glance::backend::swift':
        swift_store_user => "$tenant:$glance_user",
        swift_store_key  => $glance_password,
        swift_store_auth_address => "http://$keystone_vip:5000/v2.0",
        swift_store_create_container_on_put => true,
    }

    glance_api_config {
        'glance_store/stores':  value => 'glance.store.swift.Store';
    }

    if $role == 'primary-controller' {
        notice("Update a keystone user for Swift Cluster: ${tenant}:${swift_user}")
        class {'swift::keystone::auth':
            auth_name => $swift_user,
            password  => $swift_password,
            tenant  => $tenant,
            port => '80',
            public_protocol => 'http',
            public_address => $api_address,
            admin_protocol => 'http',
            admin_address => $api_address,
            endpoint_prefix => 'KEY',
        }
        Class['swift::keystone::auth'] ~> Service['glance-api']
    }

    notice("Start Glance API Service")
    service { 'glance-api':
        name => $glance_api,
        ensure => "running",
        hasstatus => true,
    }

    Exec['Stop glance-api'] ->
    Class['glance::backend::swift'] ->
    Service['glance-api']

    if $deployment_mode == 'ha_compact' {
        service { 'swift-proxy':
            name      => $swift_proxy,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }

        service { 'swift-object':
            name      => $swift_object,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-object-auditor':
            name      => $swift_object_auditor,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-object-replicator':
            name      => $swift_object_replicator,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-container':
            name      => $swift_container,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-container-auditor':
            name      => $swift_container_auditor,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-container-replicator':
            name      => $swift_container_replicator,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-container-updater':
            name      => $swift_container_updater,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-container-sync':
            name      => $swift_container_sync,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }


        service { 'swift-account':
            name      => $swift_account,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-account-auditor':
            name      => $swift_account_auditor,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-account-replicator':
            name      => $swift_account_replicator,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
        service { 'swift-account-reaper':
            name      => $swift_account_reaper,
            ensure    => "stopped",
            enable    => false,
            hasstatus => true,
        }
    }

}
