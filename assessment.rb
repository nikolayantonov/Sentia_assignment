require 'json'

instance_type="t2.nano"

tempHash = {
    "AWSTemplateFormatVersion" => "2010-09-09",
    "Description" => "AWS CloudFormation Assessment Template.",
    "Parameters" => {
      "Keyname" => {"Description" => "Name of an existing EC2 KeyPair to enable SSH access to the instance",
                    "Type" => "AWS::EC2::KeyPair::KeyName",
                    "ConstraintDescription" => "must be the name of an existing EC2 keypair"},
      "SSHLocation" => {"Description" => "The IP address range..."},
    },
    "Resources" => {
      "myS3Bucket" => { "Type" => "AWS::S3::Bucket"},
      "EC2Instance" => {"Type" => "AWS::EC2::Instance",
                        "Properties" => {
                          "InstanceType" => instance_type,
                          "SecurityGrops" => [{"Ref" => "InstanceSecurityGroup"}],
                          "SubnetId" => {"Ref" => "SubnetA"},
                          "KeyName" => {"Ref" => "KeyName"},
                          "ImageId" => "ami-08935252a36e25f85"
                        }
      },
      "InstanceSecurityGroup" => {"Type" => "AWS::EC2::SecurityGroup"},
      "myVPC" => {"Type" => "AWS::EC2::VPC"},
      "InternetGateway" => {"Type" => "AWS::EC2::InternetGateway"},
      "VPCGatewayAttachment" => {"Type" => "AWS::EC2::VPCGatewayAttachment"},
      "SubnetA" => {"Type" => "AWS::EC2::Subnet"},
      "SubnetB" => {"Type" => "AWS::EC2::Subnet"},
      "SubnetC" => {"Type" => "AWS::EC2::Subnet"},
      "RouteTable" => {"Type" => "AWS::EC2::RouteTable"},
      "InternetRoute" => {"Type" => "AWS::EC2::Route"},
      "SubnetARouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation"},
      "SubnetBRouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation"},
      "SubnetCRouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation"},
      "SecurityGroup" => {"Type" => "AWS::EC2::SecurityGroup"}
  }
}

File.open("assessment_output.json","w") do |f|
  f.write(JSON.pretty_generate(tempHash))
end
