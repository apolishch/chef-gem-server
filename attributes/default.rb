default['gem_server']['port']=8808
case node['platform_family']
when 'mac_os_x'
  default['gem_server']['gem_dir']='/usr/share/gem_server/gems'
end
