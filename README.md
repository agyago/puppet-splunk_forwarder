# splunk_forwarder

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with splunk_forwarder](#setup)
    * [What splunk_forwarder affects](#what-splunk_forwarder-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with splunk_forwarder](#beginning-with-splunk_forwarder)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module provides a method to deploy splunk forwarders to windows and linux. This includes with some common configurations. All parameters can be changed from hiera: installation media, version, etc. 

## Setup

### Setup Requirements **OPTIONAL**

This assumes that you already have splunk enterprise server set up. This is only for forwarders.

### Beginning with splunk_forwarder

Define your splunk servers and if possible the binaries for the forwarders ( they can be chanegd in hiera )

## Usage

the basic way of adding this splunk forwarder module to other module or role is to define the logs you want it to digest and pass it to the index server. 
example:
```bash
drovio
├── manifests
│   ├── init.pp
│   ├── splunk_forwarder.pp
│   ├── test.pp
```

```
class drovio::splunk_forwarder {
  include splunk_forwarder

  $log_files = "/var/log/drovio/*.log"
  splunk_forwarder::input{
    'drovio_logs':
      target_index => 'itsys_drovio',
      disabled     => 'false',
      input_file   => $log_files,
  }

}
```
it can have multiple logs too.
```
class tableau::splunk_forwarder{
  tag 'tableau_splunk_forwarder'

  include splunk_forwarder

  $log_file1 = '/var/opt/tableau/tableau_server/data/tabsvc/logs/vizportal/*.log'
  splunk_forwarder::input{
    'tableau_logs1':
      target_index => 'itsys_tableau',
      sourcetype   => 'catalina',
      disabled     => 'false',
      input_file   => $log_file1,
  }

  $log_file2 = '/var/opt/tableau/tableau_server/data/tabsvc/logs/tabadmincontroller/*.log'
  splunk_forwarder::input{
    'tableau_logs2':
      target_index => 'itsys_tableau',
      sourcetype   => 'catalina',
      disabled     => 'false',
      input_file   => $log_file2,
  }
  ```
