name             'keystone'
maintainer       'Leonid Laboshin'
maintainer_email 'laboshinl@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures keystone'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

supports 'gentoo'
%w[gentoo mysql libcloud].each do |dep|
  depends dep
end
