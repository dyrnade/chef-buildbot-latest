# Cookbook Name:: buildbot
# Recipe:: worker
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

slave_basedir = ::File.join(node['buildbot']['worker']['deploy_to'],
                            node['buildbot']['worker']['basedir'])
options       = node['buildbot']['worker']['options']
host          = node['buildbot']['master']['host']
port          = node['buildbot']['worker']['port']
worker_name    = node['buildbot']['worker']['name']
password      = node['buildbot']['worker']['password']
worker_tac     = ::File.join(worker_basedir, 'buildbot.tac')
worker_new_tac = "#{worker_tac}.new"
worker_info    = ::File.join(worker_basedir, 'info')
worker_admin   = ::File.join(worker_info, 'admin')
worker_host    = ::File.join(worker_info, 'host')
host_info     = node['buildbot']['worker']['host_info']


# Install the Python package
python_package "buildbot-worker" do
  action :install
end

# Deploy the worker
directory node['buildbot']['worker']['deploy_to'] do
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0755"
  action :create
end

execute "Start the worker" do
  command "buildbot-worker restart #{worker_basedir}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  action :nothing
end

execute "Change new config" do
  command "mv #{worker_new_tac} #{worker_tac}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  only_if { File.exists?(worker_new_tac) }
  action :nothing
end

file "worker info admin" do
  path worker_admin
  content "#{node['buildbot']['worker']['admin']}\n"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0644"
  action :nothing
end

template "worker info host" do
  path worker_host
  source "host.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0644"
  action :nothing
end

execute "Create worker" do
  command "buildbot-worker create-worker #{options} #{worker_basedir} #{host}:#{port} #{worker_name} #{password}"
  user node['buildbot']['user']
  group node['buildbot']['group']
  notifies :run, resources(:execute => "Change new config"), :immediately
  notifies :create, resources(:file => "worker info admin"), :immediately
  notifies :create, resources(:template => "worker info host"), :immediately
  notifies :run, resources(:execute => "Start the worker")
end
