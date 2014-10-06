class openvpn_as ($openvpn_location, $password) {
    class openvpn_downloader {
      exec { "/usr/bin/env wget -O openvpn_as.deb --timestamping ${openvpn_location}":
        alias => "exec_openvpn_download",
        cwd => "/tmp",
      }

      exec { "/usr/bin/env dpkg -i -fnoninteractive /tmp/openvpn_as.deb":
        require => Exec["exec_openvpn_download"],
      }
    }

    class { 'openvpn_downloader': }

    user { 'openvpn':
      ensure => "present",
      password => $password,
      require => Class["openvpn_downloader"]
    }

    ufw::allow { 'allow943':
      port => 943,
    }
}
