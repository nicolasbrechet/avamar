# == Class: avamar::register
# This will register the client with the Avamar Grid.
# This requires that a host and a domain be provided.
#
# === Authors
# Ronald Valente <rawn027@gmail.com>
#
# === Copyright
# Copyright 2103 Ronald Valente
#
class avamar::register inherits avamar::params {

  case $::osfamily {
    Windows: {
      exec { 'register':
        command     => "cd \"${pkg_path}\"; .\\avregister.bat \"${host}\" \"${domain}\";",
        # TODO: check if we can use cwd => "${pkg_path}"
        refreshonly => true,
        subscribe   => Class['avamar::install'],
        provider    => "powershell",
      } ->
      service { 'avbackup':
        enable     => true,
        ensure     => running,
        hasrestart => true,
        hasstatus  => true,
        require    => Class['avamar::install'],
      }
    }
    default: {
      exec { 'register':
        command     => "$avagent register $host $domain",
        path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin", "/usr/local/sbin" ],
        onlyif      => "test `$avagent status | grep -c $host` -ne 1",
        refreshonly => true,
        subscribe   => Class['avamar::install'],
        before      => Service['avagent'],
      }

      service { 'avagent':
        enable     => true,
        ensure     => running,
        hasrestart => true,
        hasstatus  => true,
        require    => Class['avamar::install'],
      }
    }
  }
}
