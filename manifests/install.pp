# == Class: avamar::install
# This will install the latest avamar client package.
#
# === Authors
# Ronald Valente <rawn027@gmail.com>
#
# === Copyright
# Copyright 2103 Ronald Valente
#
class avamar::install inherits avamar::params {

  if($avamar::params::local_dir == ''){
    include wget
    $base_url  = "https://${avamar::params::host}"
    $pkg_url   = "${base_url}${avamar::params::pkg_loc}"
    # Hostname must be a string
    validate_string($host)

    wget::fetch { "avamar_pkg":
      source             => "$pkg_url",
      destination        => "${avamar::params::pkg_dir}/${avamar::params::pkg}",
      timeout            => 0,
      verbose            => false,
      nocheckcertificate => true,
      notify             => Package[$avamar::params::pkg_name],
    }

    package { $avamar::params::pkg_name:
      provider => $avamar::params::provider,
      ensure   => installed,
      source   => "${avamar::params::pkg_dir}/${avamar::params::pkg}",
      require  => Wget::Fetch["avamar_pkg"],
    }
  }else{
      package { $avamar::params::pkg_name:
      ensure   => installed,
      source   => "$avamar::params::local_dir",
      install_options => ['/qn'],
    }
  }
}
