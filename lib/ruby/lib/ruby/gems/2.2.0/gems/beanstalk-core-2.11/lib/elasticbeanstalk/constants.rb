
#==============================================================================
# Copyright 2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

module ElasticBeanstalk

    class Constants
        LOG_SHIFT_SIZE = 10485760  # max size of each log file: 10 MB
        LOG_SHIFT_AGE = 5          # rotation limit of log files: 5

        @@deploy_config_dir = '/opt/elasticbeanstalk/deploy/configuration/'
        @@appsourceurl_file = File.join(@@deploy_config_dir, 'appsourceurl')
        @@containerconfig_file = File.join(@@deploy_config_dir, 'containerconfiguration')
        @@sourcebundle_file = '/opt/elasticbeanstalk/deploy/appsource/source_bundle'

        def self.deploy_config_dir
            @@deploy_config_dir
        end

        def self.appsourceurl_file
            @@appsourceurl_file
        end

        def self.containerconfig_file
            @@containerconfig_file
        end

        def self.sourcebundle_file
            @@sourcebundle_file
        end
    end

end
