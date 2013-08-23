#
# Cookbook Name:: gem_server
# Recipe:: default
#
# Copyright 2013, goBalto Operations
#
# All rights reserved - Do Not Redistribute
#

if node[:gem_server][:enabled]

  service "gem_server" do
    action :enable
    supports enable: true, start: true, stop: true, restart: true
  end

  directory node[:gem_server][:gem_dir] do
    owner "gb"
    recursive true
    action create
    mode "744"
  end

  case node['platform_family']
  when 'mac_os_x'
    template "org.rubyforge.rubygems.server.plist" do
      path "/Library/LaunchAgents"
      source "org.rubyforge.rubygems.server.plist.erb"
      owner "root"
      group "root"
      mode "0644"
      variables({
        gem_server_gem_dir: node[:gem_server][:gem_dir],
        gem_server_port: node[:gem_server][:port]
      })
      notifies :restart, resources(:service => "gem_server")
    end
  end

end
