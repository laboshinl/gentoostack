source "https://supermarket.getchef.com"

#cookbook "chef-solo-search"
cookbook "gentoo", git: 'https://github.com/laboshinl/chef-gentoo.git'

Dir.glob("site-cookbooks/**").select { |fn| File.directory?(fn) }.each do |path|
  cookbook File.basename(path), path: path
end

