maintainer       "Pablo Baños López"
maintainer_email "pablo@besol.es"
license          "Apache 2.0"
description      "Installs/Configures joomla"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1.4"

recipe "joomla", "Installs and configures joomla LAMP stack on a single system"

%w{ php openssl }.each do |cb|
  depends cb
end

depends "apache2", ">= 0.99.4"
depends "mysql", ">= 1.0.5"

%w{ debian ubuntu }.each do |os|
  supports os
end

  
attribute "joomla/dir",
  :display_name => "Joomla installation directory",
  :description => "Location to place joomla files.",
  :default => "/var/www"
  
attribute "joomla/db/database",
  :display_name => "Joomla MySQL database",
  :description => "Joomla will use this MySQL database to store its data.",
  :default => "joomladb"

attribute "joomla/db/user",
  :display_name => "Joomla MySQL user",
  :description => "Joomla will connect to MySQL using this user.",
  :default => "joomlauser"

attribute "joomla/db/password",
  :display_name => "Joomla MySQL password",
  :description => "Password for the Joomla MySQL user.",
  :default => "randomly generated"
  
attribute "joomla/server_aliases",
  :display_name => "Joomla Server Aliases",
  :description => "Joomla Server Aliases",
  :default => "FQDN"

attribute "joomla/zipped_source",
    :display_name => "Joomla package URL",
    :description => "URL for a zipped joomla source package",
    :default => "http://joomlacode.org/gf/download/frsrelease/16512/72867/Joomla_2.5.1-Stable-Full_Package.zip"