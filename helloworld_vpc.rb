#!/usr/bin/env ruby
require './config'

def ec2
  @ec2 ||= Aws::EC2::Client.new(region: @region)
end

def create_vpc
  cidr_block = '10.0.0.0/16'
  resp = ec2.create_vpc cidr_block: cidr_block
  @vpc_id = resp[:vpc][:vpc_id]
  resp
end

def configure_vpc_name
  raise '@vpc_id missing' unless @vpc_id
  resources = [@vpc_id]
  tags = [ { key: 'Name', value: 'myVPC'} ]
  resp = ec2.create_tags resources: resources, tags: tags
end

def run
  puts "Region: #{@region}"
  puts 'Creating VPC...';                   ap resp = create_vpc
  puts 'Configuring VPC name...';           ap resp = configure_vpc_name
  true
end
