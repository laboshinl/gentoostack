#
# Cookbook Name:: cinder
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
include_recipe 'keystone::empty'

unless node[:gentoo][:use_flags].include?('sqlite')
  node.default[:gentoo][:use_flags] << 'sqlite'
  generate_make_conf 'added mysql USE flag'
end

gentoo_package_mask '~dev-python/routes-2.0' do
  action :create
end

packages = %w(dev-python/oslo-rootwrap dev-python/rtslib-fb dev-python/networkx sys-cluster/cinder dev-python/taskflow dev-python/futures dev-python/python-barbicanclient)

packages.each do |package|
  gentoo_package_keywords package do
    keywords '~amd64'
  end
end


package 'sys-cluster/cinder' do
  action :upgrade
end

package 'dev-python/mysql-python' do
  action :upgrade
end


mysql_user node[:glance][:db_username] do
  action :create
  password node[:glance][:db_password]
  force_password true
end

mysql_database node[:glance][:db_instance] do
  action :create
  owner node[:glance][:db_username]
end

keystone_user node[:glance][:admin_user] do
  os_endpoint node[:keystone][:os_endpoint]
  os_token    node[:keystone][:os_token]
  password    node[:glance][:admin_password]
  email       node[:glance][:admin_email]
end

keystone_user_role 'name: glance; tenant: service, role: admin' do
  os_endpoint node[:keystone][:os_endpoint]
  os_token    node[:keystone][:os_token]
  name        node[:glance][:admin_user]
  tenant      node[:glance][:admin_tenant_name]
  role        'admin'
end

keystone_service 'glance' do
  os_endpoint node[:keystone][:os_endpoint]
  os_token    node[:keystone][:os_token]
  type        'image'
  description 'OpenStack Image Service'
end

keystone_endpoint 'keystone' do
  os_endpoint node[:keystone][:os_endpoint]
  os_token    node[:keystone][:os_token]
  service     'glance'
  publicurl   lazy { "http://#{node[:glance][:host]}:9292" }
  internalurl lazy { "http://#{node[:glance][:host]}:9292" }
  adminurl    lazy { "http://#{node[:glance][:host]}:9292" }
end

connection = 'mysql://%s:%s@%s/%s' % [
  node[:glance][:db_username],
  node[:glance][:db_password],
  node[:glance][:db_hostname],
  node[:glance][:db_instance],
]

template '/etc/glance/glance-registry.conf' do
  source 'etc/glance/glance-registry.conf.erb'
  mode   00644
  owner  'glance'
  group  'glance'
  variables({
    :connection        => connection,
    :admin_tenant_name => node[:glance][:admin_tenant_name],
    :admin_user        => node[:glance][:admin_user],
    :admin_password    => node[:glance][:admin_password],
    :auth_host         => node[:keystone][:host],
  })
  notifies :restart, 'service[glance-registry]', :immediately
end

template '/etc/glance/glance-api.conf' do
  source 'etc/glance/glance-api.conf.erb'
  mode   00644
  owner  'glance'
  group  'glance'
  variables({
    :connection        => connection,
    :admin_tenant_name => node[:glance][:admin_tenant_name],
    :admin_user        => node[:glance][:admin_user],
    :admin_password    => node[:glance][:admin_password],
    :auth_host         => node[:keystone][:host],
    :rabbitmq_host     => node[:rabbitmq][:host],
    :rabbitmq_userid   => node[:rabbitmq][:username],
    :rabbitmq_password => node[:rabbitmq][:password],
  })
  notifies :restart, 'service[glance-api]', :immediately
end

template '/etc/glance/glance-registry-paste.ini' do
  source 'etc/glance/glance-registry-paste.ini.erb'
  mode   00644
  owner  'glance'
  group  'glance'
  variables({
    :connection        => connection,
    :admin_tenant_name => node[:glance][:admin_tenant_name],
    :admin_user        => node[:glance][:admin_user],
    :admin_password    => node[:glance][:admin_password],
  })
  notifies :restart, 'service[glance-registry]', :immediately
end

template '/etc/glance/glance-api-paste.ini' do
  source 'etc/glance/glance-api-paste.ini.erb'
  mode   00644
  owner  'glance'
  group  'glance'
  variables({
    :admin_tenant_name => node[:glance][:admin_tenant_name],
    :admin_user        => node[:glance][:admin_user],
    :admin_password    => node[:glance][:admin_password],
  })
  notifies :restart, 'service[glance-api]', :immediately
end

file '/var/lib/glance/glance.sqlite' do
  action :delete
end

execute 'glance db sync' do
  user    'glance'
  group   'glance'
  command 'glance-manage db_sync'
end
