#
# Cookbook Name:: rax-serf
# Recipe:: default
#
# Copyright (C) 2014 Rackspace
#
# All rights reserved - Do Not Redistribute
#

require 'base64'


if node[:rax_serf][:raw_encrypt_key]
  node.set[:serf][:agent][:encrypt_key] =      \
    Base64.encode64(node[:rax_serf][:raw_encrypt_key]).chop
end

node[:network][:interfaces][:eth2][:addresses].each_pair do |addr,info|
  if info[:family] == "inet"
    node.set[:serf][:agent][:bind] = addr
    break
  end
end

include_recipe 'serf::default'
