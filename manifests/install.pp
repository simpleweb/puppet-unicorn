class unicorn::install {

  package { 'unicorn':
    ensure => installed,
    provider => 'gem',
    require => Package['ruby1.9.1-dev'],
  }

  package { 'ruby1.9.1-dev':
    ensure => present
  }

}
