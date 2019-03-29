def get_region_from_config
  aws_config_content = File.read(File.expand_path('~/.aws/config'))
  aws_config_content.match(/^\s*region\s*=\s*(\S+)\s*$/)[1]
end
