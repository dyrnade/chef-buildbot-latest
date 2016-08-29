# Cookbook Name:: buildbot
# Recipe:: workers
#
#
# Cem Guresci <gurescicem@gmail.com>
#

include_recipe "buildbot::_common"

worker_basedir = ::File.join(node['buildbot']['worker']['deploy_to'],
                            node['buildbot']['worker']['basedir'])
options       = node['buildbot']['worker']['options']
host          = node['buildbot']['master']['host']
port          = node['buildbot']['worker']['port']
worker_name    = node['buildbot']['worker']['name']
password      = node['buildbot']['worker']['password']
worker_tac     = ::File.join(worker_basedir, 'buildbot.tac')
worker_info    = ::File.join(worker_basedir, 'info')
worker_admin   = ::File.join(worker_info, 'admin')
worker_host    = ::File.join(worker_info, 'host')
host_info     = node['buildbot']['worker']['host_info']
master_ipaddress = ''

if Chef::Config[:solo]
  Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
else
  nodes = search(:node, "tags:buildbot_master AND chef_environment:#{node.chef_environment}")
  master_ipaddress = nodes[0]['ipaddress']
end

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

template "Change new config" do
  path worker_tac
  source "worker.cfg.erb"
  owner node['buildbot']['user']
  group node['buildbot']['group']
  mode "0644"
  action :nothing
  variables(
      :worker_dir   => worker_basedir,
      :worker_port  => node['buildbot']['worker']['port'],
      :master_host  => master_ipaddress
  )
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
  notifies :create, resources(:template => "Change new config"), :immediately
  notifies :create, resources(:file => "worker info admin"), :immediately
  notifies :create, resources(:template => "worker info host"), :immediately
  notifies :run, resources(:execute => "Start the worker")
end

tag('buildbot_worker')