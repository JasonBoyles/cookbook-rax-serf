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

node.set[:serf][:version] = '0.5.0'
node.set[:serf][:agent][:interface] = 'eth2'

node[:network][:interfaces][:eth0][:addresses].each_pair do |addr,info|
  if info[:family] == 'inet'
    node.set[:serf][:node_name] = node[:hostname] + "-" + addr
    break
  end
end

include_recipe 'serf::default'
