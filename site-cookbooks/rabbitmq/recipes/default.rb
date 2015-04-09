#
# Cookbook Name:: rabbitmq
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

gentoo_package_keywords 'net-misc/rabbitmq-server' do
  keywords '~amd64'
end

package 'net-misc/rabbitmq-server'

#template '/etc/rabbitmq/rabbitmq.config' do
#  source 'etc/rabbitmq/rabbitmq.config.erb'
#end

service 'rabbitmq' do
  supports :status => true, :restart => true
  action [ :enable, :start ]
#  subscribes :restart, resources(:template => '/etc/rabbitmq/rabbitmq.config')
  subscribes :restart, resources(:package => 'net-misc/rabbitmq-server')
end

bash 'configure rabbitmq users' do
  user  'root'
  group 'root'
  code <<-EOF
    if rabbitmqctl list_users | egrep -q '^#{node[:rabbitmq][:username]}[[:space:]]+'
    then
      rabbitmqctl change_password \
        #{node[:rabbitmq][:username]} \
        #{node[:rabbitmq][:password]}
    else
      rabbitmqctl add_user \
        #{node[:rabbitmq][:username]} \
        #{node[:rabbitmq][:password]}
    fi
  EOF
end