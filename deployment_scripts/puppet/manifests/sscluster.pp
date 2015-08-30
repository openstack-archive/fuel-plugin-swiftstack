$fuel_settings = parseyaml(file('/etc/astute.yaml'))


if $fuel_settings['swiftstack']['metadata']['enabled'] {

    notice("Enable SwiftStack Swift cluster ingegtation in $deployment_mode")
    $role = $fuel_settings['role']
    $deployment_mode  = $fuel_settings['deployment_mode']
    $keystone_vip  = $fuel_settings['management_vip']

    $swift_api_address   = $fuel_settings['swiftstack']['swift_api_address']
    $swift_user     = 'swift'
    $swift_password = $fuel_settings['swift']['user_password']
    $glance_user     = 'glance'
    $glance_password = $fuel_settings['glance']['user_password']
    $default_tenant   = $fuel_settings['workloads_collector']['tenant']

    class {'sscluster':
        deployment_mode => $deployment_mode,
        keystone_vip => $keystone_vip,
        api_address => $swift_api_address,
        swift_user => $swift_user,
        swift_password => $swift_password,
        glance_user => $glance_user,
        glance_password => $glance_password,
        tenant => $default_tenant,
        role => $role,
    }

} else {
    notice("Disable SwiftStack Swift cluster ingegration")
}
