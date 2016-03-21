notice('PLUGIN: SwiftStack Swift cluster integration/sscluster-tls-cert.pp')

$swiftstack = hiera_hash('swiftstack', {})

if $swiftstack['metadata']['enabled'] {

  # Plugin options
  $swift_api_address   = $swiftstack['swift_api_address']
  $swift_api_fqdn   = $swiftstack['swift_api_fqdn']
  $swift_tls_cert = $swiftstack['swift_tls_cert']
  $swift_tls_enabled  = pick($swiftstack['swift_tls_enabled'], false)

  file { '/etc/hiera/plugins/sscluster.yaml':
    ensure  => file,
    content => template('sscluster/hiera-override.yaml.erb'),
  }
}
