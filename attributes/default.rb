default['gem_server']['port']=8808
default['gem_server']['service_description']="Custom Ruby Gem Server"
default['gem_server']['gem_path'] = "/usr/bin/gem"
default['gem_server']['gem_dir']='/usr/share/gem_server/gems'

case node['platform_family']
when "mac_os_x"

when "arch", "suse", "fedora"

when "debian", "gentoo" , "rhel", "solaris2"
  default['gem_server']['gem_run_levels'] = [3,5]
  default['gem_server']['not_gem_run_levels'] = [0,1,2,6]

when "slackware", "openbsd"

when "omnios"

when "windows"

else

end