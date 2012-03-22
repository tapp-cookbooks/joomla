#
# Author:: Pablo Baños López (<pablo@besol.es>)
# Cookbook Name:: joomla
# Attributes:: joomla
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

# General settings
default['joomla']['dir'] = "/var/www/joomla"
default['joomla']['db']['database'] = "joomladb"
default['joomla']['db']['user'] = "joomlauser"
default['joomla']['server_aliases'] = [node['fqdn']]
default['joomla']['zipped_source'] = "http://joomlacode.org/gf/download/frsrelease/16512/72867/Joomla_2.5.1-Stable-Full_Package.zip"

override['mysql']['bind_address'] = '127.0.0.1'
