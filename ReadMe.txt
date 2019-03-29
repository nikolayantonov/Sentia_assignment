Task:

Running ruby assessment.rb should produce a json output that represents a proper
cloudformation template and follows the requirements stated above.

Process:

1) Created helloworld infra using native aws-sdk-ruby to test ruby installation
https://github.com/aws/aws-sdk-ruby/tree/version-2

2) ruby assessment.rb command implies no dsl generators can be used to generate CFN template,
so these solutions should be discarded, even though these could be useful:
https://medium.com/boltops/why-generate-cloudformation-templates-with-lono-65b8ea5eb87d
https://github.com/bazaarvoice/cloudformation-ruby-dsl
https://github.com/tongueroo/lono
https://www.sparkleformation.io/
https://github.com/cfndsl/cfndsl
https://github.com/seanedwards/cfer


3) Created CloudFormation json as a reference model for ruby-generated json

4) Generated json using ruby json pretty_generate api
