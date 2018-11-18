#!/usr/bin/env bash
export PATH=/bin:/usr/bin:$PATH

CHEF_VERSION="3.5.13"

source /etc/lsb-release
#env

sudo apt-get update
#install vagrant and virtualbox
DEBIAN_FRONTEND=noninteractive sudo apt-get -y install vagrant virtualbox
#install chefdk
dpkg -l chefdk || rm -f /tmp/chefdk.deb && wget -O /tmp/chefdk.deb https://packages.chef.io/files/stable/chefdk/${CHEF_VERSION}/ubuntu/${DISTRIB_RELEASE}/chefdk_${CHEF_VERSION}-1_amd64.deb && sudo dpkg -i /tmp/chefdk.deb && rm -f /tmp/chefdk.deb 
