# encoding: UTF-8
#
# Cookbook Name:: openstack-image
# Attributes:: default
#
# Copyright 2012, Rackspace US, Inc.
# Copyright 2013, Craig Tracey <craigtracey@gmail.com>
# Copyright 2013, Opscode, Inc.
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

# Set to some text value if you want templated config files
# to contain a custom banner at the top of the written file
default['openstack']['image']['custom_template_banner'] = '
# This file autogenerated by Chef
# Do not edit, changes will be overwritten
'

default['openstack']['image']['verbose'] = 'False'
default['openstack']['image']['debug'] = 'False'
# This is the name of the Chef role that will install the Keystone Service API
default['openstack']['image']['identity_service_chef_role'] = 'os-identity'

# Gets set in the Image Endpoint when registering with Keystone
default['openstack']['image']['region'] = node['openstack']['region']

# The name of the Chef role that knows about the message queue server
# that Glance uses
default['openstack']['image']['rabbit_server_chef_role'] = 'os-ops-messaging'

default['openstack']['image']['service_tenant_name'] = 'service'
default['openstack']['image']['service_user'] = 'glance'
default['openstack']['image']['service_role'] = 'admin'

default['openstack']['image']['notification_driver'] = 'noop'

# Set the number of api workers
default['openstack']['image']['api']['workers'] = [8, node['cpu']['total'].to_i].min

# Return the URL that references where the data is stored on the backend.
default['openstack']['image']['api']['show_image_direct_url'] = 'False'

default['openstack']['image']['api']['auth']['version'] = node['openstack']['api']['auth']['version']
default['openstack']['image']['registry']['auth']['version'] = node['openstack']['api']['auth']['version']

# Keystone PKI signing directories
# XXX keystoneclient wants these dirs to exist even if it doesn't use them
default['openstack']['image']['api']['auth']['cache_dir'] = '/var/cache/glance/api'
default['openstack']['image']['registry']['auth']['cache_dir'] = '/var/cache/glance/registry'

# Whether to use any of the default caching pipelines from the paste configuration file
default['openstack']['image']['api']['caching'] = false
default['openstack']['image']['api']['cache_management'] = false

default['openstack']['image']['api']['default_store'] = 'file'

default['openstack']['image']['filesystem_store_datadir'] = '/var/lib/glance/images'

default['openstack']['image']['api']['swift']['container'] = 'glance'
default['openstack']['image']['api']['swift']['large_object_size'] = '200'
default['openstack']['image']['api']['swift']['large_object_chunk_size'] = '200'
default['openstack']['image']['api']['swift']['enable_snet'] = 'False'
default['openstack']['image']['api']['swift']['store_region'] = nil
default['openstack']['image']['api']['cache']['image_cache_max_size'] = '10737418240'

# Directory for the Image Cache
default['openstack']['image']['cache']['dir'] = '/var/lib/glance/image-cache/'
# Number of seconds until an incomplete image is considered stalled an
# eligible for reaping
default['openstack']['image']['cache']['stall_time'] = 86400
# Number of seconds to leave invalid images around before they are eligible to be reaped
default['openstack']['image']['cache']['grace_period'] = 3600

# Ceph Options
default['openstack']['image']['api']['rbd']['rbd_store_ceph_conf'] = '/etc/ceph/ceph.conf'
default['openstack']['image']['api']['rbd']['rbd_store_user'] = 'glance'
default['openstack']['image']['api']['rbd']['rbd_store_pool'] = 'images'
default['openstack']['image']['api']['rbd']['rbd_store_chunk_size'] = '8'
# The name used for the data bag item containing the Cephx user's password
default['openstack']['image']['api']['rbd']['key_name'] = 'rbd-image'

# API to use for accessing data. Default value points to sqlalchemy
# package.
default['openstack']['image']['data_api'] = 'glance.db.sqlalchemy.api'

# Default Image Locations
default['openstack']['image']['upload_images'] = ['cirros']
default['openstack']['image']['upload_image']['cirros'] = 'http://download.cirros-cloud.net/0.3.2/cirros-0.3.2-x86_64-disk.img'

# logging attribute
default['openstack']['image']['syslog']['use'] = false
default['openstack']['image']['syslog']['facility'] = 'LOG_LOCAL2'
default['openstack']['image']['syslog']['config_facility'] = 'local2'

# vmware attributes
default['openstack']['image']['api']['vmware']['secret_name'] = 'openstack_vmware_secret_name'
default['openstack']['image']['api']['vmware']['vmware_server_host'] = ''
default['openstack']['image']['api']['vmware']['vmware_server_username'] = ''
default['openstack']['image']['api']['vmware']['vmware_datacenter_path'] = ''
default['openstack']['image']['api']['vmware']['vmware_datastore_name'] = ''
default['openstack']['image']['api']['vmware']['vmware_api_retry_count'] = 10
default['openstack']['image']['api']['vmware']['vmware_task_poll_interval'] = 5
default['openstack']['image']['api']['vmware']['vmware_store_image_dir'] = '/openstack_glance'
default['openstack']['image']['api']['vmware']['vmware_api_insecure'] = false

# cron output redirection
default['openstack']['image']['cron']['redirection'] = '> /dev/null 2>&1'

# platform-specific settings
case platform_family
when 'fedora', 'rhel' # :pragma-foodcritic: ~FC024 - won't fix this
  default['openstack']['image']['user'] = 'glance'
  default['openstack']['image']['group'] = 'glance'
  default['openstack']['image']['platform'] = {
    'postgresql_python_packages' => ['python-psycopg2'],
    'mysql_python_packages' => ['MySQL-python'],
    'db2_python_packages' => ['python-ibm-db', 'python-ibm-db-sa'],
    'image_packages' => %w{openstack-glance cronie python-glanceclient},
    'image_client_packages' => ['python-glanceclient'],
    'ceph_packages' => ['python-ceph'],
    'swift_packages' => ['openstack-swift'],
    'image_api_service' => 'openstack-glance-api',
    'image_registry_service' => 'openstack-glance-registry',
    'image_api_process_name' => 'glance-api',
    'package_overrides' => ''
  }
when 'suse'
  default['openstack']['image']['user'] = 'openstack-glance'
  default['openstack']['image']['group'] = 'openstack-glance'
  default['openstack']['image']['platform'] = {
    'postgresql_python_packages' => ['python-psycopg2'],
    'mysql_python_packages' => ['python-mysql'],
    'image_packages' => ['openstack-glance', 'python-glanceclient'],
    'image_client_packages' => ['python-glanceclient'],
    'ceph_packages' => [],
    'swift_packages' => ['openstack-swift'],
    'image_api_service' => 'openstack-glance-api',
    'image_registry_service' => 'openstack-glance-registry',
    'image_api_process_name' => 'glance-api',
    'package_overrides' => ''
  }
when 'debian'
  default['openstack']['image']['user'] = 'glance'
  default['openstack']['image']['group'] = 'glance'
  default['openstack']['image']['platform'] = {
    'postgresql_python_packages' => ['python-psycopg2'],
    'mysql_python_packages' => ['python-mysqldb'],
    'image_packages' => ['glance'],
    'image_client_packages' => ['python-glanceclient'],
    'ceph_packages' => ['python-ceph'],
    'swift_packages' => ['python-swift'],
    'image_api_service' => 'glance-api',
    'image_registry_service' => 'glance-registry',
    'image_registry_process_name' => 'glance-registry',
    'package_overrides' => "-o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-confdef'"
  }
end

default['openstack']['image']['platform']['service_provider'] = node['openstack']['common']['platform']['service_provider']

