notice('PLUGIN: SwiftStack Swift cluster integration/sscluster-hosts.pp')

$swiftstack = hiera_hash('swiftstack', {})

if $swiftstack['metadata']['enabled'] {

  # Plugin options
  $swift_api_address   = $swiftstack['swift_api_address']
  $swift_api_fqdn   = $swiftstack['swift_api_fqdn']
  $swift_tls_enabled  = pick($swiftstack['swift_tls_enabled'], false)

  if !empty($swift_api_fqdn) {
    host { $swift_api_fqdn:
      name   => $swift_api_fqdn,
      ensure => present,
      ip     => $swift_api_address,
    }
  }
}
