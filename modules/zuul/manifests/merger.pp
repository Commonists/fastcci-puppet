# Copyright 2012-2013 Hewlett-Packard Development Company, L.P.
# Copyright 2014 OpenStack Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

# == Class: zuul::merger
#
class zuul::merger (
    $git_dir = '/var/lib/zuul/git'
) {
    service { 'zuul-merger':
        name       => 'zuul-merger',
        enable     => true,
        hasrestart => true,
        require    => File['/etc/init.d/zuul-merger'],
    }

    file { '/etc/zuul/merger-logging.conf':
        ensure => present,
        source => 'puppet:///modules/zuul/merger-logging.conf',
    }

    cron { 'zuul_repack':
        user        => 'jenkins',
        hour        => '4',
        minute      => '7',
        command     => "MAILTO='jenkins-bot@wikimedia.org' find ${git_dir} -maxdepth 3 -type d -name '.git' -exec git --git-dir='{}' pack-refs --all \\;",
        environment => 'PATH=/usr/bin:/bin:/usr/sbin:/sbin',
        require     => [
            Package['jenkins'],  # provides 'jenkins' user
            File[$git_dir],
        ],
    }
}
