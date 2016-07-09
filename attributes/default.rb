default['redmine']['version'] = "2.5"
default['redmine']['user'] = "apache"
default['redmine']['group'] = "apache"
default['redmine']['root_dir'] = "/usr/local"
default['redmine']['log_rotate'] = 31
default['redmine']['url'] ="http://svn.redmine.org/redmine/branches/#{node['redmine']['version']}-stable"
