require 'json'

instance_type="t2.nano"
allowed_ssh = "35.158.238.101/32"
latest_ami_id = "ami-08935252a36e25f85"
random_bucket_name = "bucket_" + ('0'..'z').to_a.shuffle.first(8).join

tempHash = {
    "AWSTemplateFormatVersion" => "2010-09-09",
    "Description" => "AWS CloudFormation Assessment Template.",
    "Parameters" => {
      "KeyName" => {"Description" => "Name of an existing EC2 KeyPair to enable SSH access to the instance",
                    "Type" => "AWS::EC2::KeyPair::KeyName",
                    "Default" => "aws_sentia_assignment",
                    "ConstraintDescription" => "must be the name of an existing EC2 keypair"},
      },
    "Resources" => {
      "S3Bucket" => { "Type" => "AWS::S3::Bucket",
                              "Properties" => {
                                "BucketName" => random_bucket_name
                              }
      },
      "SSHSecurityGroup" => {"Type" => "AWS::EC2::SecurityGroup",
                          "Properties" => {
                             "GroupName" => "Internet Group",
                             "GroupDescription" => "SSH traffic in, all traffic out.",
                             "VpcId" => { "Ref" => "myVPC" },
                             "SecurityGroupIngress" => [
                                {
                                   "IpProtocol" => "tcp",
                                   "FromPort" => 22,
                                   "ToPort" => 22,
                                   "CidrIp" => "35.158.238.101/32"
                                }
                             ],
                             "SecurityGroupEgress" => [
                                {
                                   "IpProtocol" => "-1",
                                   "CidrIp" => "0.0.0.0/0"
                                }
                             ]
                          }
      },
      "EC2Instance" => {"Type" => "AWS::EC2::Instance",
                        "Properties" => {
                          "InstanceType" => instance_type,
                          "SecurityGroupIds" => [{ "Ref" => "SSHSecurityGroup" }],
                          "SubnetId" => {"Ref" => "SubnetA"},
                          "KeyName" => {"Ref" => "KeyName"},
                          "ImageId" => latest_ami_id
                        }
      },
      "myVPC" => {"Type" => "AWS::EC2::VPC",
                  "Properties" => {
                    "CidrBlock" => "10.0.0.0/16",
                    "EnableDnsSupport" => false,
                    "EnableDnsHostnames" => false,
                    "InstanceTenancy" => "default"
                  }
      },
      "InternetGateway" => {"Type" => "AWS::EC2::InternetGateway"},
      "VPCGatewayAttachment" => {"Type" => "AWS::EC2::VPCGatewayAttachment",
                                "Properties" => {
                                   "VpcId" => { "Ref" => "myVPC" },
                                   "InternetGatewayId" => { "Ref" => "InternetGateway" }
                                }
      },
      "SubnetA" => {"Type" => "AWS::EC2::Subnet",
                    "Properties" => {
                       "AvailabilityZone" => "eu-west-1a",
                       "VpcId" => { "Ref" => "myVPC" },
                       "CidrBlock":"10.0.0.0/20",
                       "MapPublicIpOnLaunch":true
                    }
      },
      "SubnetB" => {"Type" => "AWS::EC2::Subnet",
                    "Properties" => {
                       "AvailabilityZone" => "eu-west-1b",
                       "VpcId" => { "Ref" => "myVPC" },
                       "CidrBlock":"10.0.16.0/20",
                       "MapPublicIpOnLaunch":true
                    }
      },
      "SubnetC" => {"Type" => "AWS::EC2::Subnet",
                    "Properties" => {
                       "AvailabilityZone" => "eu-west-1c",
                       "VpcId" => { "Ref" => "myVPC" },
                       "CidrBlock":"10.0.32.0/20",
                       "MapPublicIpOnLaunch":true
                    }
      },
      "RouteTable" => {"Type" => "AWS::EC2::RouteTable",
                       "Properties" => {
                          "VpcId" => { "Ref" => "myVPC" }
                       }
      },
      "InternetRoute" => {"Type" => "AWS::EC2::Route",
                          "DependsOn" => "VPCGatewayAttachment",
                          "Properties" => {
                             "DestinationCidrBlock" => "0.0.0.0/0",
                             "GatewayId" => { "Ref" => "InternetGateway" },
                             "RouteTableId" => { "Ref" => "RouteTable" }
                          }
      },
      "SubnetARouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation",
                                        "Properties" => {
                                           "RouteTableId" => { "Ref" => "RouteTable" },
                                           "SubnetId" => { "Ref" => "SubnetA" }
                                        }
      },
      "SubnetBRouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation",
                                        "Properties" => {
                                           "RouteTableId" => { "Ref" => "RouteTable" },
                                           "SubnetId" => { "Ref" => "SubnetB" }
                                        }
      },
      "SubnetCRouteTableAssociation" => {"Type" => "AWS::EC2::SubnetRouteTableAssociation",
                                        "Properties" => {
                                           "RouteTableId" => { "Ref" => "RouteTable" },
                                           "SubnetId" => { "Ref" => "SubnetC" }
                                        }
      }
  }
}

File.open("assessment_output.json","w") do |f|
  f.write(JSON.pretty_generate(tempHash))
end
