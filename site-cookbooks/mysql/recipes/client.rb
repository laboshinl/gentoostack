include_recipe 'gentoo'

gentoo_package_mask 'dev-db/mysql'

gentoo_package_keywords 'dev-db/mariadb' do
  keywords '~amd64'
end

gentoo_package_use 'dev-db/mariadb' do
  use 'minimal'
  not_if { node.run_list?('recipe[mysql::server]')}
end

package 'dev-db/mariadb'

template '/root/.my.cnf' do
  source 'root/dotmy.cnf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
      :password => node['mysql']['password']['root'],
      :host => node['mysql']['host'],
      :encoding => 'utf8'
  )
end

chef_gem 'mysql' do
  action :install
  compile_time false
end

