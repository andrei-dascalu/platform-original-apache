#!/opt/elasticbeanstalk/lib/ruby/bin/ruby

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
require 'elasticbeanstalk/log-streaming-config-manager'

if __FILE__ == $0
  begin
    log_streaming_config_manager = ElasticBeanstalk::LogStreamingConfigManager.new
    log_streaming_config_manager.config_cwl_agent
  rescue Exception => ex
    puts ex.message
    exit(1)
  end
end
