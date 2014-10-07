# = Class: nagios_common::commands
# Collection of custom nagios check plugins we use
#
# [*config_dir*]
#   The base directory to put configuration directory in.
#   Defaults to '/etc/icinga/'
#
# [*owner*]
#   The user which should own the check config files.
#   Defaults to 'icinga'
#
# [*group*]
#   The group which should own the check config files.
#   Defaults to 'icinga'
#
class nagios_common::commands(
    $config_dir = '/etc/icinga',
    $owner = 'icinga',
    $group = 'icinga',
) {

    file { "$config_dir/commands":
        ensure => directory,
        owner  => $owner,
        group  => $group,
        mode   => '0755',
    }

    nagios_common::check_command { [
        'check_graphite',
        'check_dsh_groups',
        'check_wikidata',
        'check_cert',
        'check_solr',
        'check_all_memcached.php',
        'check_to_check_nagios_paging',
        'check_ifstatus_nomon',
    ] :
        require    => File["$config_dir/commands"],
        config_dir => $config_dir,
        owner      => $owner,
        group      => $group,
    }

    nagios_common::check_command::config { [
        'users',
        'telnet',
        'ssh',
        'snmp',
        'real',
        'radius',
        'rpc-nfs',
        'tcp_udp',
        'apt',
        'breeze',
        'dhcp',
        'disk-smb',
        'disk',
        'dns',
        'dummy',
        'flexlm',
        'ftp',
        'http',
        'ifstatus',
        'ldap',
        'load',
        'mail',
        'mrtg',
        'mysql',
        'netware',
        'news',
        'nt',
        'ntp',
        'pgsql',
        'ping',
        'procs',
        'vsz',
    ] :
        require    => File["$config_dir/commands"],
        config_dir => $config_dir,
        owner      => $owner,
        group      => $group,
    }

    nagios_common::check_command { 'check_ssl_cert':
        require       => File["$config_dir/commands"],
        config_dir    => $config_dir,
        owner         => $owner,
        group         => $group,
        plugin_source => 'puppet:///modules/nagios_common/check_commands/check_ssl_cert/check_ssl_cert',
    }
}
