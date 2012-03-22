#
# Author:: Pablo Baños López (<pablo@besol.es>)
# Cookbook Name:: joomla
# Recipe:: default
#
# Copyright 2012, Besol Soluciones S.L.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "apache2"
include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"


node.set['joomla']['db']['password'] = secure_password

remote_file "#{Chef::Config[:file_cache_path]}/joomla.zip" do
  source node['joomla']['zipped_source']
  mode "0644"
end

directory "#{node['joomla']['dir']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

package 'unzip'

bash "Extract joomla" do
  user 'root'
  code "unzip #{Chef::Config[:file_cache_path]}/joomla.zip -d #{node['joomla']['dir']}"
end

bash "Assign property of dir #{node['joomla']['dir']} to www-data user" do
    user 'root'
    code "chown -R www-data:www-data #{node['joomla']['dir']}"
end

execute "Install mysql joomla privileges" do
  command "/usr/bin/mysql -u root -p#{node['mysql']['server_root_password']} < #{node['mysql']['conf_dir']}/joomla-grants.sql"
  action :nothing
end

template "#{node['mysql']['conf_dir']}/joomla-grants.sql" do
  source "grants.sql.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user     => node['joomla']['db']['user'],
    :password => node['joomla']['db']['password'],
    :database => node['joomla']['db']['database']
  )
  notifies :run, "execute[Install mysql joomla privileges]", :immediately
end

execute "Create #{node['joomla']['db']['database']} database" do
  command "/usr/bin/mysqladmin -u root -p#{node['mysql']['server_root_password']} create #{node['joomla']['db']['database']}"
  not_if do
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['joomla']['db']['database'])
  end
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end

# save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

log "Navigate to 'http://#{node['fqdn']}' to complete joomla installation." 
log "Joomla DB: '#{node['joomla']['db']['database']}'"
log "Joomla DB password: '#{node['joomla']['db']['password']}'"
log "Joomla DB user: '#{node['joomla']['db']['user']}'"

apache_site "000-default" do
  enable false
end

web_app "joomla" do
  template "joomla.conf.erb"
  docroot "#{node['joomla']['dir']}"
  server_name node['fqdn']
  server_aliases node['joomla']['server_aliases']
end
