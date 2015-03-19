#
# Cookbook Name:: horizon
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
"dev-python/python-heatclient",
"dev-python/django-compressor",
"dev-python/python-neutronclient",
"dev-python/python-novaclient",
"dev-python/versiontools",
"dev-python/cliff",
"dev-python/python-troveclient",
"dev-python/django-openstack-auth",
"www-apps/horizon",
"dev-python/django-appconf",
"dev-python/python-ceilometerclient",
"dev-python/lesscpy"
]

packages.each_with_index do |package, index|
  gentoo_package_keywords package do
    keywords "~amd64"
  end
end

package "www-apps/horizon" do
  action :upgrade
end