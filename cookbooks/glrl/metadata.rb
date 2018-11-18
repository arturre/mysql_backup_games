name 'glrl'
maintainer 'Artur'
maintainer_email 'artur.reznikov@gmail.com`'
license 'All Rights Reserved'
description 'Installs/Configures glrl'
long_description 'Installs/Configures glrl'
version '0.1.0'
chef_version '>= 13.0'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/glrl/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/glrl'


depends 'nfs', '~> 2.6.3'
depends 'mysql', '~> 8.5.1'
depends 'lvm', '~> 4.5.1'
