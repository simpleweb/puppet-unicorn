# define: unicorn::app
#
#   Creates a unicorn app service
#
# Parameters:
#
#   [*approot*]            - Path to the Rack application root. Your config.ru
#                            file should be in this directory
#   [*pidfile*]            - Filepath to read / write the PID to
#   [*socket*]             - Filepath to create the socket file
#   [*config_file*]        - Path to your app's unicorn config file
#   [*user*]               - User to run the unicorn process as (root)
#   [*group*]              - Group to run the unicorn process as (root)
#   [*rack_env*]           - Environment to run your Rack app under (production)
#   [*bundler_executable*] - Path to bundler executable (bundle)
#   [*bin_path*]           - Path to the unicorn binary (unicorn)
#   [*unicorn_options*]    - Unicorn start options (--daemonize --env \
#                            ${rack_env} --config-file ${config_file})
#   [*env_file*]           - Path to a file of environment variables to load
#                            before running unicorn, via `source` (undef)
#
# Example usage:
#
#   unicorn::app { "acme":
#     approot     => "/home/acme/rackapp",
#     pidfile     => "/home/acme/rackapp/tmp/pids/unicorn.pid",
#     socket      => "/home/acme/rackapp/tmp/sockets/unicorn.sock",
#     config_file => "/home/acme/rackapp/config/unicorn.rb",
#     user        => "acme",
#     group       => "acme",
#     rack_env    => "production",
#     env_file    => "/home/acme/.localrc"
#   }
#
# Commands available from example above:
#
#   $ service unicorn_acme
#   Usage: /etc/init.d/unicorn_acme {start|stop|restart|status}
#
define unicorn::app (
  $approot,
  $pidfile,
  $socket,
  $config_file,
  $workers            = $::processorcount,
  $user               = 'root',
  $group              = 'root',
  $rack_env           = 'production',
  $bundler_executable = 'bundle',
  $bin_path           = 'unicorn',
  $unicorn_opts       = undef,
  $env_file           = undef,
) {

  if $unicorn_opts {
    $_unicorn_opts = $unicorn_opts
  } else {
    $_unicorn_opts = "--daemonize --env ${rack_env} --config-file ${config_file}"
  }

  $daemon      = $bundler_executable
  $daemon_opts = "exec ${bin_path} ${_unicorn_opts}"

  service { "unicorn_${name}":
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    start      => "/etc/init.d/unicorn_${name} start",
    stop       => "/etc/init.d/unicorn_${name} stop",
    restart    => "/etc/init.d/unicorn_${name} reload",
    require    => [
      File["/etc/init.d/unicorn_${name}"],
      File["/etc/default/unicorn_${name}"],
    ],
  }

  file { "/etc/default/unicorn_${name}":
    owner   => root,
    group   => root,
    mode    => 644,
    content => template("unicorn/default-unicorn.erb"),
    notify  => Service["unicorn_${name}"];
  }

  file { "/etc/init.d/unicorn_${name}":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("unicorn/init-unicorn.erb"),
    notify  => Service["unicorn_${name}"];
  }
}
