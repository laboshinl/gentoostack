#
# Cookbook Name:: neutron
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

packages = %w[
  dev-python/oslo-config
  dev-python/python-neutronclient
  dev-python/oslo-i18n
  dev-python/py-amqp
  dev-python/oslo-utils
  dev-python/stevedore
  dev-python/paste
  dev-python/oslo-context
  dev-python/oslo-messaging
  dev-python/anyjson
  dev-python/python-keystoneclient
  dev-python/cliff
  dev-python/repoze-lru sys-cluster/neutron dev-python/kombu
  dev-python/oslo-middleware
  dev-python/netaddr
  net-misc/openvswitch
  dev-python/keystonemiddleware
  dev-python/python-novaclient
  dev-python/jsonrpclib dev-python/iso8601
  dev-python/prettytable
  dev-python/oslo-rootwrap
  dev-python/routes
  dev-python/netifaces dev-python/sqlalchemy-migrate
  dev-python/alembic
  dev-python/pbr
  dev-python/oslo-db
  dev-python/eventlet
  dev-python/oslo-serialization
]

packages.each do |package|
  gentoo_package_keywords package do
    keywords '~amd64'
  end
end

gentoo_package_mask '~dev-python/sqlalchemy-migrate-0.9.2' do
end

gentoo_package_mask '~dev-python/routes-2.0' do
end

gentoo_package_use 'dev-lang/python' do
  use 'sqlite mysql'
end

gentoo_package_use 'net-dns/dnsmasq' do
  use 'dhcp-tools'
end

gentoo_package_use 'sys-cluster/neutron' do
  use 'sqlite mysql openvswitch server l3 dhcp metadata'
end

package 'sys-cluster/neutron' do
  action :upgrade
end
