# == Define: varnish::logging::rls
#
#  Accumulate browser cache hit ratio and total request volume statistics
#  for ResourceLoader requests (/w/load.php) and report to StatsD.
#
# === Parameters
#
# [*statsd_server*]
#   StatsD server address, in "host:port" format.
#   Defaults to localhost:8125.
#
# === Examples
#
#  varnish::logging::rls {
#    statsd_server => 'statsd.eqiad.wmnet:8125
#  }
#
define varnish::logging::rls( $statsd_server = 'statsd' ) {
    include ::varnish::common

    file { '/usr/local/bin/varnishrls':
        source  => 'puppet:///modules/varnish/varnishrls',
        owner   => 'root',
        group   => 'root',
        mode    => '0555',
        require => File['/usr/local/lib/python2.7/dist-packages/cachestats.py'],
        notify  => Service['varnishrls'],
    }

    base::service_unit { 'varnishrls':
        ensure         => present,
        systemd        => true,
        strict         => false,
        template_name  => 'varnishrls',
        require        => File['/usr/local/bin/varnishrls'],
        subscribe      => File['/usr/local/lib/python2.7/dist-packages/cachestats.py'],
        service_params => {
            enable => true,
        },
    }

    nrpe::monitor_service { 'varnishrls':
        ensure       => present,
        description  => 'Varnish traffic logger - varnishrls',
        nrpe_command => '/usr/lib/nagios/plugins/check_procs -w 1:1 -a "/usr/local/bin/varnishrls" -u root',
    }
}
