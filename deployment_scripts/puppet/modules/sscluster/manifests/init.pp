
class sscluster (
    $deployment_mode,
    $keystone_vip,
    $api_address,
    $swift_user,
    $swift_password,
    $glance_user,
    $glance_password,
    $tenant,
    $role = 'controller',
)
{
    $swiftstack         = hiera_hash('swiftstack', {})
    $swift_hash         = hiera_hash('swift', {})
    
    $region             = pick($swift_hash['region'], hiera('region', 'RegionOne'))
    $ssl_hash           = hiera_hash('use_ssl', {})

    $swift_tls_enabled  = pick($swiftstack['swift_tls_enabled'])
    case $swift_tls_enabled {
        true: {
            $ssl_enabled = 'https'
        }
        default: {
            $ssl_enabled = 'http'
        }
    } 
   
    $public_protocol    = get_ssl_property($ssl_hash, {}, 'swift', 'public', 'protocol', $ssl_enabled)
    $admin_protocol     = get_ssl_property($ssl_hash, {}, 'swift', 'admin', 'protocol', $ssl_enabled)
    $internal_protocol  = get_ssl_property($ssl_hash, {}, 'swift', 'internal', 'protocol', $ssl_enabled)

    $internal_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
    $internal_auth_address  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('service_endpoint', ''), $keystone_vip])
    $auth_uri     = "${internal_auth_protocol}://${internal_auth_address}:5000/v2.0"

    $swift_as_glance_backend = $swiftstack['swift_as_glance_backend']
    if $swift_as_glance_backend {
        notice("Switch Glance backend to Swift Cluster: ${api_address}")
        class {'glance::backend::swift':
            swift_store_user => "$tenant:$glance_user",
            swift_store_key  => $glance_password,
            swift_store_region  => $region,
            swift_store_auth_address => $auth_uri,
            swift_store_create_container_on_put => true,
        }

        glance_api_config {
            'glance_store/stores':  value => 'glance.store.swift.Store';
        }
    }

    if 'primary-controller' in $role {
        notice("Update a keystone user for Swift Cluster: ${tenant}:${swift_user}")
        class {'swift::keystone::auth':
            auth_name          => $swift_user,
            password           => $swift_password,
            tenant             => $tenant,
            region             => $region,
            port               => '80',  
            public_protocol    => $public_protocol,
            public_address     => $api_address,
            admin_protocol     => $admin_protocol,
            admin_address      => $api_address,
            internal_protocol  => $internal_protocol,
            internal_address   => $api_address,
            endpoint_prefix    => 'KEY',
        }
        Class['swift::keystone::auth'] ~> Service['glance-api']
    }

    notice("Start Glance API Service")
    service { 'glance-api':
        ensure => "running",
        hasrestart => true,
        hasstatus => true,
    }

    if $swift_as_glance_backend {
        Class['glance::backend::swift'] ~> Service['glance-api']
        Glance_api_config<||> ~> Service['glance-api']
    }

}
