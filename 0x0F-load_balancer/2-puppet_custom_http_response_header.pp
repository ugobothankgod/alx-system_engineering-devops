# Use Puppet to automate the task of creating a
#customm HTTP header response

# Configure redirect for a single page(/redirect_me) and add header to display hostname
file_line { 'redirect':
  path  => '/etc/nginx/sites-enabled/default',
  match => 'server_name _;',
  line  => "server_name _;\n\tadd_header X-Served-By \"${hostname}\";\n\trewrite
^\/redirect_me http:\/\/www.html2md.software permanent;",
}

# Restart the web server after updating the settings
service { 'nginx':
  ensure    => 'running',
  enable    => true,
  subscribe => [File_line['redirect'], File_line['error_page']],
}
