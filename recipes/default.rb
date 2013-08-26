#
# Cookbook Name:: gem_server
# Recipe:: default
#
# Copyright 2013, goBalto Operations
#
# All rights reserved - Do Not Redistribute
#

if node[:gem_server][:enabled]
  @template_variables = {
      gem_server_gem_dir: node[:gem_server][:gem_dir],
      gem_server_port: node[:gem_server][:port],
      gem_server_description: node[:gem_server][:service_description],
      gem_path: node[:gem_server][:gem_path]
  }

  service "gem_server" do
    action :enable
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
      owner "root"
      group "root"
      mode "0644"
      variables(@template_variables)
      notifies :restart, resources(service: "gem_server")
    end

  when "arch", "suse", "fedora"
    template "gem_server.service" do
      path "/etc/system/systemd"
      source "gem_server_systemd.service.erb"
      owner "root"
      group "root"
      mode "0755"
      variables(@template_variables)
      notifies :restart, resources(service: "gem_server")
    end

  when "debian", "gentoo", "rhel", "solaris2"
    template "gem_server" do
      path "/etc/init.d"
      source "gem_server.sh.erb"
      owner "root"
      group "root"
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
      owner "root"
      group "root"
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
