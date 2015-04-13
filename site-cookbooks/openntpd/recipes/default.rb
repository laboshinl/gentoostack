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

package "net-misc/openntpd"

template "/etc/ntpd.conf" do
  source "ntpd.conf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :listen_on => [node[:ntpd][:listen_on]].flatten,
    :pool => node[:ntpd][:pool]
  )
end

service "ntpd" do
  action [:enable, :start]
  subscribes :restart, 'package[net-misc/openntpd]'
  subscribes :restart, 'template[/etc/ntpd.conf]'
end

if node.run_list?("recipe[iptables]")
  iptables_rule "ntpd" do
    action node[:ntpd][:listen_on].empty? ? :disable : :enable
  end
end

if node.run_list?("recipe[nagios::nrpe]")
  nrpe_command "ntpd"
end
