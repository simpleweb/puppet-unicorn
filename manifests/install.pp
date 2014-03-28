class unicorn::install {

  package { 'unicorn':
    ensure => installed,
    provider => 'gem',
  }

}
