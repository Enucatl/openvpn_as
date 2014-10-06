class openvpn_as ($openvpn_location, $password) {
  wget::fetch { $openvpn_location:
    alias => "openvpn_download",
    destination => '/tmp/openvpn_as.deb',
    cache_dir   => '/var/cache/wget',
    notify => Exec["install_openvpn"],
  }

  exec { "export DEBIAN_FRONTEND=noninteractive && /usr/bin/env dpkg -i /tmp/openvpn_as.deb":
    alias => "install_openvpn"
  }

  user { 'openvpn':
    ensure => "present",
    password => $password,
    require => Exec["install_openvpn"],
  }

  ufw::allow { 'allow943':
    port => 943,
    require => Exec["install_openvpn"],
  }
}
