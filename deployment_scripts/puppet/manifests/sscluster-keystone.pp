notice('MODULAR: SwiftStack Swift cluster integration/sscluster-keystone.pp')

$swiftstack = hiera_hash('swiftstack', {})

if $swiftstack['metadata']['enabled'] {

  # Plugin options
  $swift_api_address   = $swiftstack['swift_api_address']
  $swift_api_fqdn   = $swiftstack['swift_api_fqdn']
  $swift_tls_enabled  = pick($swiftstack['swift_tls_enabled'], false)
  $swift_endpoint_prefix  = pick($swiftstack['swift_endpoint_prefix'], 'KEY')

  $swift_hash = hiera_hash('swift', {})

  # swift_hash options
  $password           = $swift_hash['user_password']
  $auth_name          = pick($swift_hash['auth_name'], 'swift')
  $configure_endpoint = pick($swift_hash['configure_endpoint'], true)
  $service_name       = pick($swift_hash['service_name'], 'swift')
  $tenant             = pick($swift_hash['tenant'], 'services')
  $region             = pick($swift_hash['region'], hiera('region', 'RegionOne'))

  $api_address = pick($swift_api_fqdn, $swift_api_address)

  if $swift_tls_enabled {
    $swift_protocol = 'https'
    $swift_port = pick($swiftstack['port'], 443)
  }
  else {
    $swift_protocol = 'http'
    $swift_port = pick($swiftstack['port'], 80)
  }
  $swift_url          = "${swift_protocol}://${api_address}:${swift_port}/v1/${swift_endpoint_prefix}_%(tenant_id)s"
  $swift_s3_url       = "${swift_protocol}://${api_address}:${swift_port}"

  class { '::swift::keystone::auth':
    password     => $password,
    auth_name    => $auth_name,
    configure_endpoint => $configure_endpoint,
    service_name => $service_name,
    public_url   => $swift_url,
    internal_url => $swift_url,
    admin_url    => $swift_url,
    public_url_s3=> $swift_s3_url,
    internal_url_s3    => $swift_s3_url,
    admin_url_s3 => $swift_s3_url,
    region => $region,
    tenant => $tenant,
  }
}
