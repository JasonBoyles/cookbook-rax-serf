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
node.set[:serf][:agent][:snapshot_path] = File.join(node[:serf][:base_directory],"snapshot")
node.set[:serf][:user] = 'root'
node.set[:serf][:group] = 'root'

serf_node_name = ''

node[:network][:interfaces][:eth0][:addresses].each_pair do |addr,info|
  Chef::Log.info("evaluating address #{addr}")
  if info[:family] == 'inet'
    Chef::Log.info("looks like #{addr} is inet")
    serf_node_name = node[:hostname] + "-" + addr
    Chef::Log.info("set serf_node_name to #{serf_node_name}")
    break
  end
end

Chef::Log.info("serf_node_name is #{serf_node_name}")

node.set[:serf][:agent][:node_name] = serf_node_name
node.set[:serf][:event_handlers] = [ { "url" => "http://drop.duncancreek.net/hosts-event.py",
                                      "event_type" => "member-join" } ]

Chef::Log.info("serf node_name is #{node[:serf][:node_name]}")

include_recipe 'serf::default'
