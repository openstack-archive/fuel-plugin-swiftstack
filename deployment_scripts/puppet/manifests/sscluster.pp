
notice('PLUGIN: SwiftStack Swift cluster integration/sscluster.pp')

$swiftstack = hiera_hash('swiftstack', {})
$swift = hiera_hash('swift', {})
$glance = hiera_hash('glance', {})

if $swiftstack['metadata']['enabled'] {

    notice("Enable SwiftStack Swift cluster ingegtation in $deployment_mode")
    $role = hiera('roles')
    $deployment_mode = hiera('deployment_mode')
    $keystone_vip = pick($swift['management_vip'], hiera('management_vip'))


    $swift_api_address   = $swiftstack['swift_api_address']
    $swift_user     = pick($swift['user'], 'swift')
    $swift_password = $swift['user_password']
    $glance_user     = pick($glance['user'],'glance')
    $glance_password = $glance['user_password']
    $default_tenant   = pick($swift['tenant'], 'services')

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
