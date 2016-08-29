# Cookbook Name:: buildbot
# Recipe:: _common
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

# Needed to install Python packages
include_recipe "poise-python::default"

# Add user and group for Buildbot
group node['buildbot']['group']

user node['buildbot']['user'] do
  comment "Buildbot user"
  gid node['buildbot']['group']
  system true
  shell "/bin/false"
end

python_package 'six' do
  action :install
  version '1.10.0'
end

package 'build-essential' do
  action :install
end
