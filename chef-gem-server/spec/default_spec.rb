require "chefspec"
require "fauxhai"

describe "chef-gem-server::default" do
  context "on mac os x" do
    before{ Fauxhai.mock(platform: 'mac_os_x', version: '10.7.4')}
    it "should start the gem server service" do
      chef_run = ChefSpec::ChefRunner.new('..') do |node|
        node.default['gem_server'] = {'enabled' => true}
      end
      chef_run.converge "chef-gem-server::default"

      chef_run.should create_directory '/usr/share/gem_server/gems'
      chef_run.should create_file "/Library/LaunchAgents/org.rubyforge.rubygems.server.plist"
      chef_run.file("/Library/LaunchAgents/org.rubyforge.rubygems.server.plist").should be_owned_by('root', 'root')
      chef_run.should start_service 'gem_server'
      chef_run.should set_service_to_start_on_boot 'gem_server'
    end
  end
  context "on ubuntu" do
    before{ Fauxhai.mock(platform: 'ubuntu', version: '12.04')}
    it "should start the gem server service" do
      chef_run = ChefSpec::ChefRunner.new('..') do |node|
        node.default['gem_server'] = {'enabled' => true}
      end
      chef_run.converge "chef-gem-server::default"

      chef_run.should create_directory '/usr/share/gem_server/gems'
      chef_run.should create_file "/etc/init.d/gem_server"
      chef_run.file("/etc/init.d/gem_server").should be_owned_by('root', 'root')
      chef_run.should start_service 'gem_server'
      chef_run.should set_service_to_start_on_boot 'gem_server'
    end
  end

  context "on fedora" do
    before{ Fauxhai.mock(platform: 'fedora', version: '18')}
    it "should start the gem server service" do
      chef_run = ChefSpec::ChefRunner.new('..') do |node|
        node.default['gem_server'] = {'enabled' => true}
      end
      chef_run.converge "chef-gem-server::default"

      chef_run.should create_directory '/usr/share/gem_server/gems'
      chef_run.should create_file "/etc/system/systemd/gem_server.service"
      chef_run.file("/etc/system/systemd/gem_server.service").should be_owned_by('root', 'root')
      chef_run.should start_service 'gem_server'
      chef_run.should set_service_to_start_on_boot 'gem_server'
    end
  end

  #TODO: Figure out slackware ohai settings and submit patch to fauxhai
  #context "on slackware" do
  #  before{ Fauxhai.mock(platform: 'slackware', version: '14.0')}
  #  let(:chef_run) {ChefSpec::ChefRunner.new.converge "chef-gem-server::default"}
  #  it "should start the gem server service" do
  #    chef_run.should create_directory '/usr/share/gem_server/gems'
  #    chef_run.should create_file "/etc/rc.d/gem_server"
  #    chef_run.file("/etc/rc.d/gem_server").should be_owned_by('root', 'root')
  #    chef_run.should start_service 'gem_server'
  #    chef_run.should set_service_to_start_on_boot 'gem_server'
  #  end
  #end
end