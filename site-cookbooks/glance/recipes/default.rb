#
# Cookbook Name:: glance
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
include_recipe "gentoo"

packages = [
  "dev-python/repoze-lru",
  "dev-python/pbr",
  "dev-python/oslo-vmware",
  "dev-python/oslo-serialization",
  "dev-python/iso8601",
  "dev-python/python-keystoneclient",
  "dev-python/oslo-utils",
  "dev-python/oslo-config",
  "dev-python/retrying",
  "dev-python/sqlalchemy-migrate", 
  "dev-python/paste",
  "dev-python/kombu",
  "app-admin/glance",
  "dev-python/routes", 
  "dev-python/keystonemiddleware",
  "dev-python/WSME",
  "dev-python/python-swiftclient",
  "dev-python/oslo-i18n",
  "dev-python/glance_store",
  "dev-python/oslo-context",
  "dev-python/oslo-middleware",
  "dev-python/stevedore",
  "dev-python/anyjson",
  "dev-python/ordereddict",
  "dev-python/python-cinderclient",
  "dev-python/boto",
  "dev-python/netifaces",
  "dev-python/prettytable",
  "dev-python/posix_ipc",
  "dev-python/osprofiler",
  "dev-python/suds",
  "dev-python/oslo-messaging",
  "dev-python/eventlet",
  "dev-python/oslo-db",
  "dev-python/jsonschema",
  "dev-python/netaddr",
  "dev-python/py-amqp",
  "dev-python/alembic"
]

packages.each do |package|
  gentoo_package_keywords package do
    keywords "~amd64"
  end
end

gentoo_package_mask "~dev-python/routes-2.0" do
end

gentoo_package_use "dev-lang/python" do
  use "sqlite mysql"
end

gentoo_package_use "sys-auth/keystone" do
  use "sqlite mysql -swift"
end

package "app-admin/glance" do
  action :upgrade
end
