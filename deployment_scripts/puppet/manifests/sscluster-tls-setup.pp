notice('MODULAR: SwiftStack Swift cluster integration/sscluster-tls-setup.pp')

$swiftstack = hiera_hash('swiftstack', {})

if $swiftstack['metadata']['enabled'] {

  # Plugin options
  $swift_api_address   = $swiftstack['swift_api_address']
  $swift_api_fqdn   = $swiftstack['swift_api_fqdn']
  $swift_tls_enabled  = pick($swiftstack['swift_tls_enabled'], false)
  $swift_tls_cert = $swiftstack['swift_tls_cert']

  if !empty($swift_api_fqdn) {
    host { $swift_api_fqdn:
      name   => $swift_api_fqdn,
      ensure => present,
      ip     => $swift_api_address,
    }
  }

  # Add TLS certificate

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  if $swift_tls_enabled and !empty($swift_tls_cert) {
    Exec {
      path => '/bin:/usr/bin:/sbin:/usr/sbin',
    }

    case $::osfamily {
      'RedHat': {
        file { '/etc/pki/ca-trust/source/anchors/swiftstack.pem':
          ensure  => file,
          content => $swift_tls_cert['content'],
          notify  => Exec['enable_trust'],
        }

        exec { 'enable_trust':
          command     => 'update-ca-trust force-enable',
          refreshonly => true,
          notify      => Exec['add_trust_redhat'],
        }

        exec { 'add_trust_redhat':
          command     => 'update-ca-trust extract',
          refreshonly => true,
        }
      }

      'Debian': {
        file { '/usr/local/share/ca-certificates/swiftstack.crt':
          ensure  => file,
          content => $swift_tls_cert['content'],
          notify  => Exec['add_trust_debian'],
        }

        exec { 'add_trust_debian':
          command     => 'update-ca-certificates',
          refreshonly => true,
        }
      }

      default: {
        fail("Unsupported OS: ${::osfamily}/${::operatingsystem}")
      }
    }
  }
  else {
    notice("WARNING: you enabled TLS for SwiftStack plugin but did not specified self-signed certificate for adding to OS trust chain. Assuming usage of trusted SwiftStack cert")
  }
}
