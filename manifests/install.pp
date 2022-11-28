class splunk_forwarder::install (
  $splunk_file,
  $splunk_pkg,
  $provider,
  $splunk_admin_pass_hashed,
  $source
){
#Hiera will determine OS family
  if $facts['kernel']=='Linux'{
    file { "/tmp/${splunk_file}":
      source  => $source,
      replace => 'no',
      mode    => '0644';
  }
  ensure_packages(
  {
    $splunk_pkg =>
      {
        source => "/tmp/${splunk_file}",
        provider => $provider,
        require => File["/tmp/${splunk_file}"]
      }
  }, {'ensure' => 'present'} )
  }
  elsif $facts['kernel']=='windows'{
    file { 'C:/temp':
      ensure => directory,
    }
    file { "C:/temp/${splunk_file}":
      source  => $source,
      replace => false,
    }
    package { $splunk_pkg:
      ensure          => 'installed',
      provider        => $provider,
      source          => "C:/temp/${splunk_file}",
      install_options => [{'AGREETOLICENSE' => 'YES'}, {'LOGIN_USERNAME' => 'splunkadmin'},
      {'LOGIN_PASSWORD' => $splunk_admin_pass_hashed},'/quiet'],
      require         => File["C:/temp/${splunk_file}"],

    }
  }
  else {
    fail(" ${facts['kernel']} is currently not supported for installing/configure splunk forwarders.")
  }
}