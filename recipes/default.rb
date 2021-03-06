#
# Cookbook Name:: storm-project
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w[ curl unzip build-essential pkg-config libtool autoconf git-core uuid-dev python-dev ].each do |pkg|
    package pkg do
        retries 2
        action :install
    end
end

bash "Storm install" do
  user node[:storm][:deploy][:user]
  cwd "/home/#{node[:storm][:deploy][:user]}"
  code <<-EOH
  mkdir storm-data || true
  wget #{node[:storm][:zip_url]}
  unzip apache-storm-#{node[:storm][:version]}.zip
  cd apache-storm-#{node[:storm][:version]}
  EOH
  not_if do
    ::File.exists?("/home/#{node[:storm][:deploy][:user]}/apache-storm-#{node[:storm][:version]}")
  end
end

execute "reload upstart configuration" do
  command "initctl reload-configuration"
  action :nothing
end

directory "/var/log/storm" do
  owner node.storm.deploy.user
  group node.storm.deploy.user
  recursive true
end
