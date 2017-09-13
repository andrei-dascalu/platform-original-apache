
#==============================================================================
# Copyright 2017 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       https://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================

require 'aws-sdk'
require 'elasticbeanstalk/environment'
 
module ElasticBeanstalk
    module Clients
        def self.s3_resource
            Aws::S3::Resource.new(client: self.s3_client)
        end

        def self.s3_client
            @@s3_client ||= Aws::S3::Client.new(region: Environment.region)
        end
    end
end
