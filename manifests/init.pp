# == Class: hazelcast
#
# Full description of class hazelcast here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'hazelcast':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Frank Premereur <frank.premereur@emsa.europa.eu>
#
# === Copyright
#
# Copyright 2016 EMSA, unless otherwise noted.
#
class hazelcast (
	$version	= '3.4.2',
	$uri		= 'http://download.hazelcast.com/download.jsp',
	$pkg		= "/tmp/hazelcast-$version.tar.gz",
	$home		= '/star'
) {
	
	Exec { path 	=>
		['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/']
	}

  case $operatingsystem {
    'RedHat', 'CentOS': { ensure_packages('wget', 'tree', 'openjdk-8-jdk', 'unzip', 'lsof', 'vim-enhanced') }
    default:            { ensure_packages('wget', 'tree', 'java-1.8.0-openjdk', 'unzip', 'lsof', 'vim') }  
  }

	exec {'download-hazelcast':
		command	=> "wget $uri --post-data \"version=hazelcast-$version&type=tar&p=\" -O $pkg",
		unless	=> "test -f $pkg",
		require	=> Package['wget'],
	}

	file {"$home":
		ensure	=> directory,
	}

	file {"$home/hazelcast":
		ensure	=> link,
		target	=> "$home/hazelcast-$version",
		require	=> File["$home"],
		before	=> Exec['unpack-hazelcast'],
	}

	exec {'unpack-hazelcast':
		command	=> "tar -xf $pkg -C $home",
		unless	=> "test -f $home/hazelcast-$version/release_notes.txt",
		require	=> Exec['download-hazelcast'],
	}

}
