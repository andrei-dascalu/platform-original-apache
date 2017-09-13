
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
  module EventUtils
    def self.emit_event(msg, severity = 'INFO')
      event_file = ENV['EB_EVENT_FILE'] || '/dev/stderr'
      event = {
        msg: msg,
        severity: severity,
        timestamp: Time.new.to_i
      }

      File.open event_file, 'a' do |file|
        file.write JSON.pretty_generate(event)
        file.write "\n---\n"
      end
    end

    def self.fail_with_event(msg)
      emit_event(msg, 'ERROR')
      puts msg
      exit 1
    end
  end
end
