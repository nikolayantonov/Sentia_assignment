gem 'aws-sdk', '~> 2'

require 'ap'
require 'aws-sdk'
require './helpers'

@region = get_region_from_config
