name 'iptables'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs the iptables daemon and provides a LWRP for managing rules'
version '1.0.1'

recipe 'default', 'Installs iptables and sets up .d style config directory of iptables rules'
%w(gentoo).each do |os|
  supports os
end

depends 'gentoo'
