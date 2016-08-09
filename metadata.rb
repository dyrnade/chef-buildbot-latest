maintainer       "Cem Guresci"
maintainer_email "gurescicem@gmail.com"
name              "buildbot"
license          "Apache 2.0"
description      "Installs and configures a Buildbot master and/or slave"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
recipe           "buildbot", "Install a master and slave Buildbot with the default configuration"
recipe           "buildbot::master", "Install and configure a Buildbot master"
recipe           "buildbot::worker", "Install and configure a Buildbot worker"

depends "poise-python"
depends "apt"

%w{redhat centos scientific fedora debian ubuntu}.each do |os|
    supports os
end
