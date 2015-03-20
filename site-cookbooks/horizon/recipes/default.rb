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
include_recipe 'gentoo'
include_recipe 'nginx'

packages = %w[
  dev-python/python-heatclient
  dev-python/django-compressor
  dev-python/python-neutronclient
  dev-python/python-novaclient
  dev-python/versiontools
  dev-python/cliff
  dev-python/python-troveclient
  dev-python/django-openstack-auth
  www-apps/horizon
  dev-python/django-appconf
  dev-python/python-ceilometerclient
  dev-python/lesscpy
]

packages.each do |package|
  gentoo_package_keywords package do
    keywords '~amd64'
  end
end

package 'www-apps/horizon'

gentoo_package_use 'www-servers/uwsgi' do
  use 'python'
end

template '/usr/lib64/python2.7/site-packages/openstack_dashboard/local/local_settings.py' do
  source 'usr/lib64/python2.7/site-packages/openstack_dashboard/local/local_settings.py.erb'
end

template '/etc/nginx/conf.d/horizon.conf' do
  source 'etc/nginx/conf.d/horizon.conf.erb'
  notifies :restart, 'service[nginx]'
end

template '/usr/lib64/python2.7/site-packages/openstack_dashboard/wsgi/wsgi.py' do
  source 'usr/lib64/python2.7/site-packages/openstack_dashboard/wsgi/wsgi.py.erb'
end

template '/etc/uwsgi.d/uwsgi.horizon' do
  source 'etc/uwsgi.d/uwsgi.horizon.erb'
end

link '/etc/init.d/uwsgi.horizon' do
  to '/etc/init.d/uwsgi'
end

