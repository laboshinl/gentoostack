#
# Cookbook Name:: mariadb
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

unless node[:gentoo][:use_flags].include?("mysql")
  node.default[:gentoo][:use_flags] << "mysql"
  generate_make_conf "added mysql USE flag"
end

gentoo_package_keywords "dev-db/mariadb" do
  keywords "~amd64"
end

package "dev-db/mariadb" do
  action :upgrade
end

template "/root/.my.cnf" do
  source "root/dotmy.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :password => node[:mysql][:password][:root],
    :host => node[:mysql][:host],
    :encoding => "utf8"
  )
end

template "/etc/mysql/my.cnf" do
  source "etc/mysql/my.cnf.erb"
  action :create
end

execute "emerge --config dev-db/mariadb" do
  user  "root"
  group "root"
  creates "/var/lib/mysql/mysql"
end

service "mysql" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
  subscribes :restart, resources(:package => "dev-db/mariadb", :template => "/etc/mysql/my.cnf")
end

chef_gem "mysql" do
  action :install
end

mysql_database "test" do
  action :delete
end

