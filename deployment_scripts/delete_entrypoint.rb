#!/usr/bin/env ruby
require 'hiera'

ENV['LANG'] = 'C'

hiera = Hiera.new(:config => '/etc/hiera.yaml')
swift = hiera.lookup 'swift', {} , {}
auth_addr = hiera.lookup 'management_vip', nil, {}

ENV['OS_TENANT_NAME']="services"
ENV['OS_USERNAME']="swift"
ENV['OS_PASSWORD']="#{swift['user_password']}"
ENV['OS_AUTH_URL']="http://#{auth_addr}:5000/v2.0"
ENV['OS_ENDPOINT_TYPE'] = "internalURL"

def service_list
  stdout = `keystone service-list`
  return_code = $?.exitstatus
  names = []
  uuids = []
  types = []
  stdout.split("\n").each do |line|
    fields = line.split('|').map { |f| f.chomp.strip }
    next if fields[1] == 'id'
    next unless fields[2]
    names << fields[2]
    uuids << fields[1]
    types << fields[3]
  end
  {:names => names, :uuids => uuids, :types => types, :exit_code => return_code}
end

def endpoint_list
  stdout = `keystone endpoint-list`
  return_code = $?.exitstatus
  service_ids = []
  uuids = []
  stdout.split("\n").each do |line|
    fields = line.split('|').map { |f| f.chomp.strip }
    next if fields[1] == 'id'
    next unless fields[2]
    service_ids << fields[6]
    uuids << fields[1]
  end
  {:service_ids => service_ids, :uuids => uuids, :exit_code => return_code}
end


def delete_endpoint(service_name)
  list_of_services = service_list
  list_of_endpoints = endpoint_list
  types = Hash[list_of_services[:types].map.with_index.to_a]
  service_id = list_of_services[:uuids][types[service_name]]
  endpoint_service_ids = Hash[list_of_endpoints[:service_ids].map.with_index.to_a]
  endpoint_uuid = list_of_endpoints[:uuids][endpoint_service_ids[service_id]]
  puts "Remove endpoint ('#{endpoint_uuid}') in '#{service_name}' "
       "(service_id: '#{service_id}'."
  stdout = `keystone endpoint-delete '#{endpoint_uuid}'`
end

########################


delete_endpoint("object-store")
delete_endpoint("s3")


