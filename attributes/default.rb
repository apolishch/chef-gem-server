default['gem_server']['port']=8808
default['gem_server']['service_description']="Custom Ruby Gem Server"
default['gem_server']['gem_path'] = "/usr/bin/gem"
case node['platform_family']
when "mac_os_x"
  default['gem_server']['gem_dir']='/usr/share/gem_server/gems'

when "arch", "suse", "fedora"

when "debian"
  default['gem_server']['gem_run_levels'] = [3,5]
  default['gem_server']['not_gem_run_levels'] = [0,1,2,6]

when "rhel"

when "gentoo"

when "slackware"

when "openbsd"

when "solaris2"

when "omnios"

when "windows"

else

end