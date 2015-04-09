#
# Cookbook Name:: keystone
# Recipe:: default
#
# Copyright 2015, Leonid Laboshin
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

include_recipe 'gentoo'
include_recipe 'mysql::client'
include_recipe 'libcloud'

unless node['gentoo']['use_flags'].include?('sqlite')
  node.default['gentoo']['use_flags'].push 'sqlite'
  generate_make_conf 'added mysql USE flag'
end

gentoo_package_mask '~dev-python/routes-2.0' do
  action :create
end

packages = %w(dev-python/six dev-python/oslo-config dev-python/keystonemiddleware dev-python/pbr dev-python/paste dev-python/netifaces dev-python/kombu dev-python/jsonschema dev-python/python-keystoneclient dev-python/oslo-db dev-python/pyjwt dev-python/alembic dev-python/iso8601 dev-python/oslo-middleware dev-python/stevedore dev-python/oslo-context dev-python/posix_ipc dev-python/prettytable dev-python/oslo-serialization dev-python/repoze-lru dev-python/netaddr dev-python/dogpile-core dev-python/dogpile-cache dev-python/oslo-utils dev-python/sqlalchemy-migrate dev-python/eventlet dev-python/anyjson dev-python/py-amqp dev-python/oslo-messaging dev-python/keystone dev-python/routes dev-python/oslo-i18n dev-python/oauthlib dev-python/pycadf sys-auth/keystone)

packages.each do |package|
  gentoo_package_keywords package do
    keywords '~amd64'
  end
end

package 'sys-auth/keystone' do
  action :upgrade
end

package 'dev-python/mysql-python' do
  action :upgrade
end

mysql_user node['keystone']['db_username'] do
  action :create
  password node['keystone']['db_password']
  force_password true
end

mysql_database node['keystone']['db_instance'] do
  action :create
  owner node['keystone']['db_username']
end

template '/etc/keystone/keystone.conf' do
  source 'etc/keystone/keystone.conf.erb'
  mode '0644'
  owner 'root'
  group 'root'
  variables({
    :admin_token => node['keystone']['os_token'],
    :log_dir => node['keystone']['log_dir'],
    :connection => 'mysql://%s:%s@%s/%s' % [
      node['keystone']['db_username'],
      node['keystone']['db_password'],
      node['keystone']['db_hostname'],
      node['keystone']['db_instance']
      ]
  })
end

file '/var/lib/keystone/keystone.db' do
  action :delete
end

execute 'keystone-manage db_sync' do
  action :run
end

service 'keystone' do
  action [:enable, :start]
  subscribes :restart, 'template[/etc/keystone/keystone.conf]'
end

libcloud_api_wait "localhost" do
  port "5000"
end

keystone_user 'admin' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  password    node['keystone']['admin_pass']
  email       'root@localhost'
end

keystone_role 'admin' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  action      :create
end

keystone_role '_member_' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  action      :create
end

keystone_tenant 'admin' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  description 'Admin Tenant'
  action      :create
end

keystone_user_role 'name: admin; tenant: admin, role: _member_' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  name        'admin'
  role        '_member_'
  tenant      'admin'
end

keystone_user_role 'name: admin; tenant: admin, role: admin' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  name        'admin'
  role        'admin'
  tenant      'admin'
end

keystone_user 'demo' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  password    node['keystone']['demo_pass']
  email       'demo@localhost'
end

keystone_tenant 'demo' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  description 'Demo Tenant'
end

keystone_user_role 'name: demo; tenant: demo, role: _member_' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  name        'demo'
  role        '_member_'
  tenant      'demo'
end

keystone_tenant 'service' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  description 'Service Tenant'
end

keystone_service 'keystone' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  type        'identity'
  description 'OpenStack Identity Service'
end

keystone_endpoint 'keystone' do
  os_endpoint node['keystone']['os_endpoint']
  os_token    node['keystone']['os_token']
  service     'keystone'
  publicurl   "http://#{node['keystone']['host']}:5000/v2.0"
  internalurl "http://#{node['keystone']['host']}:5000/v2.0"
  adminurl    "http://#{node['keystone']['host']}:35357/v2.0"
end
