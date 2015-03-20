name             'glance'
maintainer       'Leonid Laboshin'
maintainer_email 'laboshinl@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures glance'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'gentoo'
%w[keystone gentoo mysql].each do |dep|
  depends dep
end