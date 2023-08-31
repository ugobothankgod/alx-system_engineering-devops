# Puppet manifest, executes a bash command using an Exec resource
exec { 'kill':
  command => '/data/data/com.termux/files/usr/bin/pkill -f killmenow',
  path    => ['/usr/bin/', '/usr/sbin/'],
}
