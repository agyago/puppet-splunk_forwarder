class splunk_forwarder::post_install (
  $splunk_home,
  $splunk_indexer,
  $splunk_admin_user,
  $splunk_admin_pass,
  $splunk_admin_pass_hashed
){
  $host_name = $facts['networking']['fqdn']
  $splunk_indexer = $splunk_indexer

  file {
    "${splunk_home}/etc/system/local/user-seed.conf":
      ensure  => file,
      content => template('splunk/user-seed.conf.erb'),
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0640';
  }

  file {
    "${splunk_home}/etc/system/local/outputs.conf":
      ensure  => file,
      content => template('splunk/outputs.conf.erb'),
      owner   => 'splunk',
      group   => 'splunk',
      mode    => '0644',
      notify  => Exec['restart splunk'],
  }

  concat {
    'inputs.conf':
      path   => "${splunk_home}/etc/system/local/inputs.conf",
      owner  => 'splunk',
      group  => 'splunk',
      mode   => '0644',
      notify => Exec['restart splunk'],
  }

  splunk::forwarder::input{
    'default':
      input_file => 'default',
      host       => $host_name,
  }

  if $facts['kernel']=='Linux'{
    exec { 'stop splunk before boot-start':
      command  => 'splunk stop',
      path     => "${splunk_home}/bin/",
      user     => 'root',
      onlyif   => "test -f ${splunk_home}/ftr",
      provider => 'shell',
    }

    exec { 'splunk start at boot':
      command  => 'splunk enable boot-start --no-prompt --accept-license --answer-yes',
      path     => "${splunk_home}/bin/",
      user     => 'root',
      require  => [Exec['stop splunk before boot-start'], File["${splunk_home}/etc/system/local/user-seed.conf"]],
      onlyif   => "test -f ${splunk_home}/ftr",
      provider => 'shell',
    }

    exec { 'start splunk':
      command     => 'splunk start',
      path        => "${splunk_home}/bin/",
      user        => 'root',
      refreshonly => true,
      provider    => 'shell',
    }

    exec { 'always start splunk':
      command  => 'splunk start',
      path     => ["${splunk_home}/bin/", '/usr/bin', '/bin'],
      user     => 'root',
      onlyif   => 'splunk status | grep \'not running\'' ,
      provider => 'shell',
    }
  }
  exec { 'restart splunk':
    command     => 'splunk restart',
    path        => "${splunk_home}/bin/",
    refreshonly => true,
  }

}