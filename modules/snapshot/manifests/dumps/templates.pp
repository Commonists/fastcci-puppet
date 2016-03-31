class snapshot::dumps::templates($enable=true) {
    if ($enable) {

        include snapshot::dumps::dirs

        file { "${snapshot::dumps::dirs::dumpsdir}/templs/download-index.html":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/download-index.html",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/download-index.html',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/dvd.html":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/dvd.html",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/dvd.html',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/errormail.txt":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/errormail.txt",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/errormail.txt',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/feed.xml":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/feed.xml",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/feed.xml',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/legal.html":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/legal.html",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/legal.html',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/progress.html":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/progress.html",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/progress.html',
        }
        file { "${snapshot::dumps::dirs::dumpsdir}/templs/report.html":
            ensure => 'present',
            path   => "${snapshot::dumps::dirs::dumpsdir}/templs/report.html",
            mode   => '0644',
            owner  => 'root',
            group  => 'root',
            source => 'puppet:///modules/snapshot/dumps/templates/report.html',
        }

        $warning = "The files in this directory are maintained by puppet!\n"
        $location = "puppet:///modules/snapshot/dumps/templates\n"

        file { "${snapshot::dumps::dirs::dumpsdir}/templs/README":
            ensure  => 'present',
            path    => "${snapshot::dumps::dirs::dumpsdir}/templs/README",
            mode    => '0644',
            owner   => 'root',
            group   => 'root',
            content => "${warning}${location}",
        }
    }
}
