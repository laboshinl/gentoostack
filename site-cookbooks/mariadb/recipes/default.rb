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

gentoo_package_keywords "dev-db/mariadb" do
  keywords "~amd64"
end

packages = %w[
  dev-libs/libaio 
  dev-lang/perl 
  perl-core/Data-Dumper 
  virtual/perl-Data-Dumper 
  perl-core/File-Temp 
  virtual/perl-File-Temp
  dev-perl/Net-Daemon 
  virtual/perl-Storable 
  virtual/perl-File-Spec 
  virtual/perl-Sys-Syslog 
  virtual/perl-Time-HiRes 
  virtual/perl-Getopt-Long 
  dev-perl/PlRPC dev-perl/DBI 
  app-arch/libarchive 
  dev-db/mysql-init-scripts 
  net-misc/curl dev-util/cmake 
  dev-db/mariadb virtual/mysql 
  dev-perl/DBD-mysql
]

packages.each do |pkg|
  package pkg do
    action :upgrade
  end
end

template "/root/.my.cnf" do
  source "root/dotmy.cnf.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :password => node[:mariadb][:password][:root],
    :host => "127.0.0.1",
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