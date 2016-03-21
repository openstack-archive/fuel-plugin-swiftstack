notice('MODULAR: SwiftStack Swift cluster integration/sscluster-glance.pp')

$swiftstack = hiera_hash('swiftstack', {})

if $swiftstack['metadata']['enabled'] {

    # Plugin options
    $swift_as_glance_backend = $swiftstack['swift_as_glance_backend']

    $glance_hash = hiera_hash('glance', {})
    $management_vip = hiera('management_vip')
    $ssl_hash = hiera_hash('use_ssl', {})

    # Glance options
    $glance_user                    = pick($glance_hash['user'],'glance')
    $glance_user_password           = $glance_hash['user_password']
    $glance_tenant                  = pick($glance_hash['tenant'],'services')
    $region                         = hiera('region','RegionOne')

    $internal_auth_protocol = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'protocol', 'http')
    $internal_auth_address  = get_ssl_property($ssl_hash, {}, 'keystone', 'internal', 'hostname', [hiera('service_endpoint', ''), $management_vip])

    $auth_uri = "${internal_auth_protocol}://${internal_auth_address}:5000/"

    if $swift_as_glance_backend {
        notice("Switch Glance backend to Swift Cluster")

        class { 'glance::backend::swift':
          swift_store_user                    => "${glance_tenant}:${glance_user}",
          swift_store_key                     => $glance_user_password,
          swift_store_create_container_on_put => 'True',
          swift_store_auth_address            => "${auth_uri}/v2.0/",
          swift_store_region                  => $region,
        }
        glance_api_config {
            'glance_store/stores':  value => 'glance.store.swift.Store';
        }
        Class['glance::backend::swift'] ->
          Glance_api_config<||> ~>
            Service['glance-api']
    }

    notice("Start Glance API Service")
    service { 'glance-api':
        ensure => "running",
        hasrestart => true,
        hasstatus => true,
    }
}
