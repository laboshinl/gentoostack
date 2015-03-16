#!/bin/bash
mkdir -p /usr/local/portage/app-admin/chef-omnibus
mkdir -p /usr/local/portage/metadata
echo "masters = gentoo" >> /usr/local/portage/metadata/layout.conf
echo "PORTDIR_OVERLAY=/usr/local/portage" >> /etc/portage/make.conf
wget https://raw.githubusercontent.com/laboshinl/gentoo-overlay/master/app-admin/chef-omnibus/chef-omnibus-12.1.1.ebuild -O /usr/local/portage/app-admin/chef-omnibus/chef-omnibus-12.1.1.ebuild
wget https://raw.githubusercontent.com/laboshinl/gentoo-overlay/master/app-admin/chef-omnibus/Manifest -O /usr/local/portage/app-admin/chef-omnibus/Manifest
ACCEPT_KEYWORDS='~amd64' emerge -u chef-omnibus
emerge iproute2
ln -s /bin/ip /sbin/ip
