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

gentoo_package_mask "~dev-python/routes-2.0" do
  action :create
end

gentoo_package_use "dev-lang/python" do
  use "sqlite mysql"
end

gentoo_package_use "app-admin/glance" do
  use "sqlite mysql -swift"
end

packages = [
  "dev-python/setuptools",
  "dev-python/pep8",
  "dev-python/pbr",
  "dev-python/hacking",
  "dev-python/hacking",
  "dev-python/Babel",
  "dev-python/coverage",
  "dev-python/fixtures",
  "dev-python/mock",
  "dev-python/mox",
  "dev-python/sphinx",
  "dev-python/requests",
  "dev-python/testrepository",
  "dev-python/unittest2",
  "dev-python/testtools",
  "dev-python/psutil",
  "dev-python/psutil",
  "dev-python/mysql-python",
  "dev-python/psycopg",
  "dev-python/pysendfile",
  "dev-python/qpid-python",
  "dev-python/pyxattr",
  "dev-python/oslo-sphinx",
  "dev-vcs/git",
  "dev-lang/python",
  "dev-lang/python-exec",
  "dev-python/greenlet",
  "dev-python/sqlalchemy",
  "dev-python/anyjson",
  "dev-python/eventlet",
  "dev-python/pastedeploy",
  "dev-python/routes",
  "dev-python/webob",
  "dev-python/boto",
  "dev-python/sqlalchemy-migrate",
  "dev-python/httplib2",
  "dev-python/kombu",
  "dev-python/pycrypto",
  "dev-python/iso8601",
  "dev-python/ordereddict",
  "dev-python/oslo-config",
  "dev-python/stevedore",
  "dev-python/netaddr",
  "dev-python/keystonemiddleware",
  "dev-python/WSME",
  "dev-python/posix_ipc",
  "dev-python/python-swiftclient",
  "dev-python/oslo-vmware",
  "dev-python/paste",
  "dev-python/jsonschema",
  "dev-python/python-cinderclient",
  "dev-python/python-keystoneclient",
  "dev-python/pyopenssl",
  "dev-python/six",
  "dev-python/oslo-db",
  "dev-python/oslo-db",
  "dev-python/oslo-i18n",
  "dev-python/oslo-messaging",
  "dev-python/retrying",
  "dev-python/osprofiler",
  "dev-python/glance_store",
  "app-admin/glance"
]

gentoo_package_mask "~dev-python/routes-2.0" do
end

packages.each_with_index do |package, index|
  gentoo_package_keywords package do
    keywords "~amd64"
  end
#  puts ("( #{(index+1).to_s} of #{packages.size.to_s} )")
#  gentoo_package_use package do
#    use "-python_targets_python3_3"
#  end
  package package do
    action :upgrade
  end
end
