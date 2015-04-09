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

gentoo_package_keywords 'net-firewall/iptables' do
  keywords '~amd64'
end

package 'net-firewall/iptables'

cookbook_file "/etc/conf.d/iptables" do
  source "iptables.confd"
  owner "root"
  group "root"
  mode "0600"
end

execute "rebuild-iptables" do
  command "/usr/local/sbin/rebuild-iptables"
  action :nothing
end

directory "/etc/iptables.d" do
  owner "root"
  group "root"
  mode "0700"
end

template "/usr/local/sbin/rebuild-iptables" do
  source "rebuild-iptables.rb.erb"
  owner "root"
  group "root"
  mode "0700"
  variables(:ulogd => node.run_list?("recipe[iptables::ulogd]"))
end

iptables_rule "all_established"
iptables_rule "all_icmp"
iptables_rule "sshd" do
  variables(:sshd_port => '22')
end

execute "/usr/local/sbin/rebuild-iptables" do
  not_if { File.size?("/var/lib/iptables/rules-save") }
end

service "iptables" do
  action [ :enable, :start ]
end
