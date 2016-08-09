# Cookbook Name:: buildbot
# Attributes:: default
##
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

default['buildbot']['user'] = 'buildbot'
default['buildbot']['group'] = 'buildbot'

default['buildbot']['project']['title'] = 'Buildbot'
default['buildbot']['project']['title_url'] = 'https://launchpad.net/pyflakes'

default['buildbot']['master']['host'] = 'localhost'
default['buildbot']['master']['deploy_to'] = '/opt/buildbot'
default['buildbot']['master']['basedir'] = 'master'
default['buildbot']['master']['options'] = ''
default['buildbot']['master']['cfg'] = 'master.cfg'
default['buildbot']['master']['databases'] = [ 'sqlite:///state.sqlite' ] # 'postgresql://user:password@host/database'

default['buildbot']['worker']['port'] = '9989'
default['buildbot']['worker']['deploy_to'] = '/opt/buildbot'
default['buildbot']['worker']['options'] = ''
default['buildbot']['worker']['name'] = 'example-worker'
default['buildbot']['worker']['password'] = 'password'
default['buildbot']['worker']['basedir'] = 'worker'
default['buildbot']['worker']['admin'] = 'Your Name Here <admin@youraddress.invalid>'
default['buildbot']['worker']['host_info'] = ''

# Info for the master. This is for the case when it is deployed with chef-solo
# One Master and one worker.
# For Chef Server it should be discovered by searching
default['buildbot']['workers'] = [{
  'name'     => node['buildbot']['worker']['name'],
  'password' => node['buildbot']['worker']['password']
}]

# Docker Worker
default['buildbot']['workers']['docker'] = [
    "worker.DockerLatentWorker(
        'test-worker',
        'test-worker-password',
        docker_host=#{node['ipadress']},
        image='docker/image',
        version='version')",
]

# Change Source
default['buildbot']['change_source'] = ["changes.GitPoller(
    'git://github.com/buildbot/pyflakes.git',
    workdir='gitpoller-workdir', branch='master',
    pollinterval=300)"
]

# Builders
default['buildbot']['builders'] = [
  "util.BuilderConfig(name='runtests',
    workernames=[#{node['buildbot']['workers'].map {|s| "'#{s['name']}'" }.join(',')}],
    factory=factory)"
]

# Steps
default['buildbot']['steps'] = [
  "steps.Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')",
  "steps.ShellCommand(command=['trial', 'pyflakes'])"
]

# Schedulers
default['buildbot']['schedulers'] = [
  "schedulers.SingleBranchScheduler(
    name='all',
    change_filter=util.ChangeFilter(branch='master'),
    treeStableTimer=None,
    builderNames=['runtests'])",
  "schedulers.ForceScheduler(
    name='force',
    builderNames=['runtests'])"
]
