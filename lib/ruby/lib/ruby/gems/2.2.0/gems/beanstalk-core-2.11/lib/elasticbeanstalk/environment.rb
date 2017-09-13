
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

require 'elasticbeanstalk/environment-metadata'
require 'elasticbeanstalk/http_utils'

module ElasticBeanstalk
    module Environment

        def self.environment_id
            @@environment_id ||= metadata.environment_id
        end

        def self.region
            @@region ||= metadata.region
        end

        def self.environment_s3_bucket
            @@environment_bucket ||= metadata.environment_bucket
        end

        private
        def self.metadata
            # where is logger?
            @@environment_metadata ||= EnvironmentMetadata.new
        end
    end
end
