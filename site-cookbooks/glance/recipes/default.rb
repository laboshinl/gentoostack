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
  "dev-python/oslo-config",
  "dev-python/keystonemiddleware",
  "dev-python/pbr",
  "dev-python/paste",
  "dev-python/netifaces",
  "dev-python/kombu",
  "dev-python/jsonschema",
  "dev-python/python-keystoneclient",
  "dev-python/oslo-db",
  "dev-python/pyjwt",
  "dev-python/alembic",
  "dev-python/iso8601",
  "dev-python/oslo-middleware",
  "dev-python/stevedore",
  "dev-python/oslo-context",
  "dev-python/posix_ipc",
  "dev-python/prettytable",
  "dev-python/oslo-serialization",
  "dev-python/repoze-lru",
  "dev-python/netaddr",
  "dev-python/dogpile-core",
  "dev-python/dogpile-cache",
  "dev-python/oslo-utils",
  "dev-python/sqlalchemy-migrate",
  "dev-python/eventlet",
  "dev-python/anyjson",
  "dev-python/py-amqp",
  "dev-python/oslo-messaging",
  "dev-python/keystone",
  "dev-python/routes",
  "dev-python/oslo-i18n",
  "dev-python/oauthlib",
  "dev-python/pycadf",
  "sys-auth/keystone"
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
  use "sqlite mysql"
end

package "sys-auth/keystone" do
  action :upgrade
end
