# puppet-unicorn

A puppet module that creates unicorn services for Rack apps.

### Installation

Not yet available on Puppet Forge.

To include it as a git submodule, do something like:

    $ git submodule add git@github.com:simpleweb/puppet-unicorn.git modules/unicorn

### Usage

Declare a new unicorn service like so:

```puppet
unicorn::app { "acme":
  approot     => "/home/acme/rackapp",
  pidfile     => "/home/acme/rackapp/tmp/pids/unicorn.pid",
  socket      => "/home/acme/rackapp/tmp/sockets/unicorn.sock",
  config_file => "/home/acme/rackapp/config/unicorn.rb",
  user        => "acme",
  group       => "acme",
  rack_env    => "production",
}
```

This will create a corresponding `init.d` service as follows:

    $ service unicorn_acme
    Usage: /etc/init.d/unicorn_acme {start|stop|restart|status}

Puppet will ensure this service is running as part of the run.

### Parameters

Below is the full list of options, with defaults where appropriate:

```
[*approot*]            - Path to the Rack application root. Your config.ru
                         file should be in this directory
[*pidfile*]            - Filepath to read / write the PID to
[*socket*]             - Filepath to create the socket file
[*config_file*]        - Path to your app's unicorn config file
[*user*]               - User to run the unicorn process as (root)
[*group*]              - Group to run the unicorn process as (root)
[*rack_env*]           - Environment to run your Rack app under (production)
[*bundler_executable*] - Path to bundler executable (bundle)
[*unicorn_options*]    - Unicorn start options (--daemonize --env \
                         ${rack_env} --config-file ${config_file})
```

### Limitations & assumptions

This module **does not**

* Install Ruby
* Install Bundler
* Install the unicorn gem

This is because there are so many different ways of installing Ruby and gems

The module **assumes**

* You are using bundler

### Requirements

  * Debian 7
