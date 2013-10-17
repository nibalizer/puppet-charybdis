# Class: charybdis
#
# This module manages charybdis and its config
#
# Actions:
#
# Requires:
#  ripienaar-concat module
#
class charybdis (
  $conffile = $charybdis::params::conffile,
  $manage_package = true,
) inherits charybdis::params {

  group { 'charybdis':
    ensure => present,
  }

  anchor { 'charybdis::package::end': }

  if $manage_package {
    package { 'charybdis':
      ensure => present,
      before => Anchor['charybdis::package::end'],

    }
  }
  service { 'charybdis':
    ensure  => running,
    enable  => true,
    restart => '/bin/kill -HUP `cat /var/run/charybdis/ircd.pid`',
  }
  include concat::setup
  concat { $conffile:
    owner   => "root",
    group   => "charybdis",
    mode    => "440",
    require => Anchor['charybdis::package::end'],
    notify  => Service['charybdis'],
  }
}
