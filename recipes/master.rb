# Cookbook Name:: buildbot
# Recipe:: master
#
# Copyright 2016, Cem Guresci <gurescicem@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "buildbot::_common"
include_recipe 'apt'

master_basedir = ::File.join(node['buildbot']['master']['deploy_to'],
                             node['buildbot']['master']['basedir'])
master_cfg     = ::File.join(master_basedir,
                             node['buildbot']['master']['cfg'])
options        = node['buildbot']['master']['options']

# Install the Python package
python_package ['buildbot','buildbot-www','buildbot-waterfall-view','buildbot-console-view'] do
  action :install
  version '0.9.0rc1'
end

# Deploy the Master
directory node['buildbot']['master']['deploy_to'] do
  recursive true
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Create master" do
  command "buildbot create-master #{options} #{master_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :run
end

execute "Start the master" do
  command "buildbot restart #{master_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

template master_cfg do
  source "master.cfg.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  variables(
    :host          => node['buildbot']['master']['host'],
    :databases     => node['buildbot']['master']['databases'],
    :worker_port    => node['buildbot']['worker']['port'],
    :title         => node['buildbot']['project']['title'],
    :title_url     => node['buildbot']['project']['title_url'],
    :change_source => node['buildbot']['change_source'],
    :workers        => node['buildbot']['workers'],
    :docker_workers => node['buildbot']['workers']['docker'],
    :builders      => node['buildbot']['builders'],
    :steps         => node['buildbot']['steps'],
    :schedulers    => node['buildbot']['schedulers']
  )
  notifies :run, resources(:execute => "Start the master"), :immediately
end
