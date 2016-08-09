This work is heavily based on Nico Kadel-Garcia's buildbot cookbook.

Special thanks to  Nico Kadel-Garcia <nkadel@gmail.com>

This work wouldn't be existed without his work.

https://github.com/nkadel/chef-buildbot

Description
===========

Install a master and worker Buildbot(version 0.9.0rc1) with the default configuration

NOTE
----

[Followed latest guide] : (http://docs.buildbot.net/latest/tutorial/index.html)

Right now, this cookbook is functional and will create a _master_ and _worker_
with the same configuration the  Latest Official Guide provides and additionally it provides Docker Worker installation.

It's also highly configurable through attributes.

Requirements
============

Cookbooks
---------

* poise-python
* apt

Platform
--------

* Debian/Ubuntu
* RHEL/CentOS


Usage
=====

You can create a Buildbot box just adding the default recipe to the node's _runlist_.

But you also can create separate boxes, master and workers, by adding just the recipe `master`
or the recipe `worker`.

Test
====

You can test the cookbook on vagrant by kitchen.yml provided.

License and Author
==================

Copyright 2016, Cem Guresci <gurescicem@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
