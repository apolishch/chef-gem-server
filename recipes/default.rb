#
# Cookbook Name:: gem_server
# Recipe:: default
#
# Copyright 2013, goBalto Operations
#
# All rights reserved - Do Not Redistribute
#

node.default[:gem_server]={enabled: true, gem_dir: '/usr/share/gem_server/gems', user: 'service_user', group: "root"}

if node[:gem_server][:enabled]
  @template_variables = {
      gem_server_gem_dir: node[:gem_server][:gem_dir],
      gem_server_port: node[:gem_server][:port],
      gem_server_description: node[:gem_server][:service_description],
      gem_path: node[:gem_server][:gem_path]
  }

  group node[:gem_server][:group] do
    action :create
  end

  user node[:gem_server][:user] do
    action :create
    gid node[:gem_server][:group]
  end

  service "gem_server" do
    action :nothing
    supports enable: true, start: true, stop: true, restart: true
  end

  directory node[:gem_server][:gem_dir] do
    owner "gb"
    recursive true
    action :create
    mode "744"
  end

  case node['platform_family']
  when "mac_os_x"
    template "org.rubyforge.rubygems.server.plist" do
      path "/Library/LaunchAgents"
      source "org.rubyforge.rubygems.server.plist.erb"
      owner node[:gem_server][:user]
      group node[:gem_server][:group]
      mode "0644"
      variables(@template_variables)
      notifies :restart, resources(service: "gem_server")
    end

  when "arch", "suse", "fedora"
    template "gem_server.service" do
      path "/etc/system/systemd"
      source "gem_server_systemd.service.erb"
      owner node[:gem_server][:user]
      group node[:gem_server][:group]
      mode "0755"
      variables(@template_variables)
      notifies :restart, resources(service: "gem_server")
    end

  when "debian", "gentoo", "rhel", "solaris2"
    template "gem_server" do
      path "/etc/init.d"
      source "gem_server.sh.erb"
      owner node[:gem_server][:user]
      group node[:gem_server][:group]
      mode "0755"
      variables(@template_variables.merge({
        gem_run_levels: node[:gem_server][:gem_run_levels],
        gem_not_run_levels: node[:gem_server][:gem_not_run_levels]
      }))
      notifies :restart, resources(service: "gem_server")
    end

  when "slackware", "openbsd"
    template "gem_server" do
      path "/etc/rc.d"
      source "gem_server.sh.erb"
      owner node[:gem_server][:user]
      group node[:gem_server][:group]
      mode "0755"
      variables(@template_variables.merge({
        gem_run_levels: node[:gem_server][:gem_run_levels],
        gem_not_run_levels: node[:gem_server][:gem_not_run_levels]
      }))
      notifies :restart, resources(service: "gem_server")
    end

  when "omnios"
    return

  when "windows"
    return

  else
    return

  end


end
