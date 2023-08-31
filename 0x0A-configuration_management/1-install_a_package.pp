# Puppet manifest, used to install flask from pip3

package { 'flask':
	ensure   => '2.3.3',
	provider => 'pip3',
}
