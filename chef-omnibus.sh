#!/bin/bash
#Installs chef-12.1.1 on gentoo
locale-gen -q -G "en_US.UTF-8 UTF-8"
mkdir -p /usr/local/portage/app-admin/chef-omnibus
mkdir -p /usr/local/portage/metadata
echo "masters = gentoo" >> /usr/local/portage/metadata/layout.conf
echo "PORTDIR_OVERLAY=/usr/local/portage" >> /etc/portage/make.conf
wget -q https://raw.githubusercontent.com/laboshinl/gentoo-overlay/master/app-admin/chef-omnibus/chef-omnibus-12.1.1.ebuild -O /usr/local/portage/app-admin/chef-omnibus/chef-omnibus-12.1.1.ebuild
wget -q https://raw.githubusercontent.com/laboshinl/gentoo-overlay/master/app-admin/chef-omnibus/Manifest -O /usr/local/portage/app-admin/chef-omnibus/Manifest
ACCEPT_KEYWORDS='~amd64' emerge --quiet -u chef-omnibus
#Ohai needs ip command
emerge --quiet iproute2
#Ohai looks to /sbin/ip
ln -s /bin/ip /sbin/ip
