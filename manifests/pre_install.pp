class splunk_forwarder::pre_install {
  if $facts['kernel']=='Linux'{
    exec { 'splunk uid fix':
      command  => 'userdel splunk',
      user     => 'root',
      onlyif   => '[ $(awk -F: \'/^splunk:/ {print $3}\' /etc/passwd) -gt 999 ]',
      path     => ['/usr/bin', '/usr/sbin',],
      provider => 'shell',
    }

    user { 'splunk user':
      ensure => present,
      home   => '/opt/splunkforwarder',
      system => true,
      name   => 'splunk',
    }

    exec { 'chown splunk dir':
      command     => "chown -R splunk:splunk ${::splunk::home}",
      user        => 'root',
      refreshonly => true,
      subscribe   => Exec['splunk uid fix'],
      path        => ['/bin', '/usr/bin',],
    }

    Exec['splunk uid fix']
    -> User['splunk user']
    -> Exec['chown splunk dir']
  }
}
