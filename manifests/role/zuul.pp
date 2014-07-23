# vim: set sw=4 ts=4 expandtab:

# manifests/role/zuul.pp

# == Class: role::zuul::configuration
#
# Realm based configuration for Zuul roles.
class role::zuul::configuration {

    $merger = {
        'production' => {
            'git_dir' => '/srv/ssd/zuul/git'
        },
        'labs' => {
            # FIXME migrate under /data/project whenever bug 64868 is solved
            #   'git_dir'       => '/data/project/zuul/git',
            'git_dir' => '/srv/zuul/git'
        },
    }

} # /role::zuul::configuration

# == Class: role::zuul::labs
#
# Install the Zuul gating system suitable for the Continuous Integration labs
# instance. This role can not really be reused on a different instance since it
# hardcodes several parameters such as the Gerrit IP or the URL hostnames.
class role::zuul::labs {
    system::role { 'role::zuul::labs': description => 'Zuul on labs!' }

    include contint::proxy_zuul,
        role::zuul::configuration

    class { '::zuul':
        git_source_branch => 'labs',
    }

    # Setup the instance for labs usage
    zuulwikimedia::instance { 'zuul-labs':
        gearman_server       => '127.0.0.1',
        gearman_server_start => true,
        jenkins_server       => 'http://127.0.0.1:8080/ci',
        jenkins_user         => 'zuul',
        gerrit_server        => '127.0.0.1',
        gerrit_user          => 'jenkins',
        url_pattern          => 'http://integration.wmflabs.org/ci/job/{job.name}/{build.number}/console',
        status_url           => 'http://integration.wmflabs.org/zuul/status',
        zuul_url             => 'git://localhost',
        config_git_branch    => 'labs',
        git_dir              => $role::zuul::configuration::merger[$::realm]['git_dir'],
        statsd_host          => '',
        git_email            => "zuul-merger@${::instancename}",
        git_name             => 'Wikimedia Zuul Merger',
    }

    # Serves Zuul git repositories
    class { 'contint::zuul::git-daemon':
        zuul_git_dir => $role::zuul::configuration::merger[$::realm]['git_dir'],
    }

} # /role::zuul::labs

# Class: role::zuul::production
#
# Install the continuous integration Zuul instance for production usage.
#
# https://www.mediawiki.org/wiki/Continuous_integration/Zuul
#
# The Zuul git repositories are published over the git:// protocol by using git
# daemon. That allows remote Jenkins slaves to fetch the references crafted by
# Zuul when a change is submitted.
#
class role::zuul::production {
    system::role { 'role::zuul::production': description => 'Zuul on production' }

    # We will receive replication of git bare repositories from Gerrit
    include role::gerrit::production::replicationdest
    include contint::proxy_zuul

    class { '::zuul':
        git_source_branch => 'master',
    }

    # TODO: should require Mount['/srv/ssd']
    zuulwikimedia::instance { 'zuul-production':
        gearman_server       => '127.0.0.1',
        gearman_server_start => true,
        jenkins_server       => 'http://127.0.0.1:8080/ci',
        jenkins_user         => 'zuul-bot',
        gerrit_server        => 'ytterbium.wikimedia.org',
        gerrit_user          => 'jenkins-bot',
        url_pattern          => 'https://integration.wikimedia.org/ci/job/{job.name}/{build.number}/console',
        status_url           => 'https://integration.wikimedia.org/zuul/',
        zuul_url             => 'git://zuul.eqiad.wmnet',
        config_git_branch    => 'master',
        git_dir              => $role::zuul::configuration::merger[$::realm]['git_dir'],
        statsd_host          => 'statsd.eqiad.wmnet',
        git_email            => "zuul-merger@${::hostname}",
        git_name             => 'Wikimedia Zuul Merger',
    }

    # Serves Zuul git repositories on git://zuul.eqiad.wmnet/...
    class { 'contint::zuul::git-daemon':
        zuul_git_dir => $role::zuul::configuration::merger[$::realm]['git_dir'],
    }

} # /role::zuul::production
