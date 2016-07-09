#
# Cookbook Name:: redmine
# Recipe:: default
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

%w(
  openssl-devel
  readline-devel
  zlib-devel
  curl-devel
  libyaml-devel
  ruby20-devel
  subversion
  ImageMagick
  ImageMagick-devel
).each do |pkg|
  package pkg do
    options "--enablerepo=epel"
  end
end

%w(
  bundler
).each do |pkg|
  gem_package pkg
end

bash "redmine download" do
  user "root"
  group "root"
  cwd "#{node['redmine']['root_dir']}"
  code <<-EOC
    svn checkout #{node['redmine']['url']} redmine
    mysql -u root -p#{node['mysql']['root_password']} -e "create database redmine character set utf8;"
  EOC
  creates "#{node['redmine']['root_dir']}/redmine"
end

%w(
  configuration.yml
  database.yml
).each do |t|
  template "#{node['redmine']['root_dir']}/redmine/config/#{t}" do
    owner "#{node['redmine']['user']}"
    group "#{node['redmine']['group']}"
    mode 00644
  end
end


bash "redmine setup" do
  user "root"
  group "root"
  cwd "#{node['redmine']['root_dir']}/redmine"
  code <<-EOC
    bundle install --without development test postgresql sqlite
  EOC
  creates "#{node['redmine']['root_dir']}/redmine/Gemfile.lock"
end

log "please, input command: bundle exec rake generate_secret_token"
log "please, input command: bundle exec rake db:migrate RAILS_ENV='production'"
log "please, input command: bundle exec rake redmine:load_default_data RAILS_ENV='production'"
log "please, input command: chown #{node['redmine']['user']}:#{node['redmine']['group']} -R #{node['redmine']['root_dir']}/redmine"

gem_package "passenger"

log "please, input command: passenger-install-apache2-module"

link "/var/www/html/redmine" do
  owner "#{node['redmine']['user']}"
  group "#{node['redmine']['group']}"
  to "#{node['redmine']['root_dir']}/redmine/public"
end

