#
# Cookbook Name:: macstrap
# Recipe:: default
#
# Copyright (C) 2014 Andy Gale
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'yaml'

include_recipe 'homebrew'

# We need these even if we're going to clean

homebrew_tap 'caskroom/cask'

package "brew-cask" do
  action :install
end

# Now do the business

if node['macstrap']['action'] == 'clean'
	cask_action = :uncask
  package_action = :remove
else 
  cask_action = :cask
  package_action = :install
end

path = File.expand_path('../../../../', __FILE__)
packages = YAML.load_file(File.join(path, 'packages.yml'))

if packages && packages.key?('casks')
  packages['casks'].each.each do |p|
    homebrew_cask p do 
      action cask_action
    end
  end
end

if packages && packages.key?('packages')
  packages['packages'].each.each do |p|
    package p do 
      action package_action
    end
  end
end

if packages && packages.key?('pips')

  get_pip = File.join(Chef::Config[:file_cache_path], 'get-pip.py')

  remote_file get_pip do
    source 'https://bootstrap.pypa.io/get-pip.py'
    action :create_if_missing
  end

  execute 'install-pip' do
    command 'sudo python ' + get_pip
    not_if 'which pip'
  end 

  packages['pips'].each.each do |p|
    if package_action == :install
      execute 'pip-install-' + p do
        command 'pip install '  + p
        not_if 'pip show ' + p
      end
    else
      execute 'pip-uninstall-' + p do
        command 'pip uninstall '  + p
        only_if 'pip show ' + p      
      end
    end
  end
end

if packages && packages.key?('vagrant-plugins')
  packages['vagrant-plugins'].each.each do |p|
    if package_action == :install
      execute 'vagrant-plugins-install-' + p do
        command 'vagrant plugin install '  + p
        not_if 'vagrant plugin list | grep ' + p
      end
    else
      execute 'vagrant-plugins-install-' + p do
        command 'vagrant plugin uninstall '  + p
        only_if 'vagrant plugin list | grep ' + p
      end
    end
  end
end

if node['macstrap']['action'] == 'clean'
  package "brew-cask" do
    action :remove
  end

  homebrew_tap 'caskroom/cask' do
    action :untap
  end
end