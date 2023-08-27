# Puppet manifest, executes a bash command using an Exec resource
exec { 'kill':
  command => 'pkill -f killmenow',
  path    => ['/usr/bin', '/usr/sbin']
}
