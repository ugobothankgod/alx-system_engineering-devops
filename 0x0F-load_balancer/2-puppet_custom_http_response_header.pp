# Use Puppet to automate the task of creating a
#customm HTTP header response

# Update system repository
exec { 'update':
  command => '/usr/bin/apt-get -y update',
}

# Install Nginx
package { 'nginx':
  ensure => 'present',
}

# Configure firewall to allow request through port 80
exec { 'firewall':
  command => '/usr/sbin/ufw allow "Nginx HTTP"',
}

# Create document directory, if not present
file { '/var/www/html':
  ensure => 'directory',
  mode   => '0755',
}

# Create the index html page
file { '/var/www/html/index.html':
  ensure  => 'present',
  content => 'Hello World!',
}

# Create a webpage for error 404
file { '/var/www/html/404.html':
  ensure  => 'present',
  content => "Ceci n'est pas une page",
}

# Configure redirect for a single page(/redirect_me) and add header to display hostname
file_line { 'redirect':
  path  => '/etc/nginx/sites-enabled/default',
  match => 'server_name _;',
  line  => "server_name _;\n\tadd_header X-Served-By \"${hostname}\";\n\trewrite
^\/redirect_me https:\/\/ugox.tech permanent;",
}

# Configure redirect for 404 error page
file_line { 'error_page':
  path  =>  '/etc/nginx/sites-enabled/default',
  match =>  'listen 80 default_server;',
  line  =>  "listen 80 default_server;\n\terror_page 404 \/404.html;\n\tlocation = \/404.html
{\n\t\troot \/var\/www\/html;\n\t\tinternal;\n\t}",
}

# Restart the web server after updating the settings
service { 'nginx':
  ensure    => 'running',
  enable    => true,
  subscribe => [File_line['redirect'], File_line['error_page']],
}
