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
require 'elasticbeanstalk/container-config-manager'
require 'elasticbeanstalk/environment-metadata'
require 'elasticbeanstalk/environment'
require 'elasticbeanstalk/exceptions'
require 'elasticbeanstalk/event_utils'
require 'executor'
require 'fileutils' 

module ElasticBeanstalk
  class LogStreamingConfigManager
    
    DEFAULT_LOG_LIST = "default_log_list".freeze
    COMMON_LOG_LIST = "common_log_list".freeze
    LOG_GROUP_NAME_PREFIX = "log_group_name_prefix".freeze
    ENVIRONMENT_NAME = "environment_name".freeze
    
    RESOURCE_ALREADY_EXISTS_MESSAGE = 'Log stream for log group %s already exists. No need to create it.'.freeze
    INSUFFICIENT_PERMISSION_EVENT_MESSAGE = 'You do not have sufficient permission to access CloudWatch logs. Add the permissions logs:CreateLogStream and logs:PutLogEvents to your EC2 instance profile.'.freeze
    LOG_GROUP_NOT_FOUND_EVENT_MESSAGE = 'The specified log group %s does not exist.'.freeze
    
    CLOUDWATCH_LOG_CONFIGURATION_FILE = "/etc/awslogs/config/beanstalklogs.conf".freeze
    STREAM_LOGS_OPTION_NAMESPACE = "aws:elasticbeanstalk:cloudwatch:logs".freeze
    STREAM_LOGS_OPTION_NAME = "StreamLogs".freeze
    SINGLE_DOCKER_STDOUTERR_LOG = "/var/log/eb-docker/containers/eb-current-app/stdouterr.log".freeze
    SINGLE_DOCKER_STDOUTERR_LOG_MATCH_STRING = "/var/log/eb-docker/containers/eb-current-app/*stdouterr.log".freeze
        
    def initialize
        @config_manager = ElasticBeanstalk::ContainerConfigManager.new
    end
    
    def config_cwl_agent
        stream_logs_enabled = 'false'
        
        begin
            stream_logs_enabled = @config_manager.optionsetting(STREAM_LOGS_OPTION_NAMESPACE, STREAM_LOGS_OPTION_NAME)
        rescue ElasticBeanstalk::BeanstalkRuntimeError
            puts "Log streaming option setting is not specified, ignore cloudwatch logs setup."
        end

        #casecmp compares two strings insensitively
        if stream_logs_enabled == true || 'true'.casecmp(stream_logs_enabled) == 0
            config_cloud_watch_logs
            create_log_stream
            restart_awslogs
            puts 'Enabled log streaming.'
        else
            disable_cw_logs
            puts 'Disabled log streaming.'
        end
    end
    
    private
    def config_cloud_watch_logs
        content=""
        log_list.each do |path_to_file|
            log_path = SINGLE_DOCKER_STDOUTERR_LOG.casecmp(path_to_file) == 0 ? SINGLE_DOCKER_STDOUTERR_LOG_MATCH_STRING : path_to_file
            content += "[#{path_to_file}]\nlog_group_name=/aws/elasticbeanstalk/#{environment_name}#{path_to_file}\nlog_stream_name={instance_id}\nfile=#{log_path}*\n\n"
        end
        File.write(CLOUDWATCH_LOG_CONFIGURATION_FILE, content)
    end
    
    private
    def create_log_stream
        environment_metadata = ElasticBeanstalk::EnvironmentMetadata.new
        cloudwatch_logs = cloudwatch_logs_client
        instance_id = environment_metadata.instance_id
        log_list.each do |path_to_file|
          log_group_name="#{log_group_name_prefix}/#{environment_name}#{path_to_file}"
          begin
              cloudwatch_logs.create_log_stream({
                  log_group_name: "#{log_group_name}",
                  log_stream_name: "#{instance_id}"
              })
          rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
                puts RESOURCE_ALREADY_EXISTS_MESSAGE % log_group_name
          rescue Aws::CloudWatchLogs::Errors::AccessDeniedException => ex
                puts ex.message
                EventUtils.fail_with_event(INSUFFICIENT_PERMISSION_EVENT_MESSAGE)
          rescue Aws::CloudWatchLogs::Errors::ResourceNotFoundException => ex
                puts ex.message
                EventUtils.fail_with_event(LOG_GROUP_NOT_FOUND_EVENT_MESSAGE % log_group_name)
          end        
        end
    end
    
    private
    def log_list
      default_log_list = @config_manager.container_config(DEFAULT_LOG_LIST) || []
      common_log_list = @config_manager.container_config(COMMON_LOG_LIST) || []
      log_list = default_log_list + common_log_list    
    end
    
    private
    def log_group_name_prefix
      @config_manager.container_config(LOG_GROUP_NAME_PREFIX)
    end
    
    private
    def environment_name
      @config_manager.system_config(ENVIRONMENT_NAME)
    end
    
    private
    def cloudwatch_logs_client
        region = ElasticBeanstalk::Environment.region
        Aws::CloudWatchLogs::Client.new(region: "#{region}")
    end

    def disable_cw_logs
      stop_awslogs
      FileUtils.rm_f CLOUDWATCH_LOG_CONFIGURATION_FILE
    end
    
    private
    def restart_awslogs
        puts Executor::Exec.sh("service awslogs restart")
    end
    
    private
    def stop_awslogs
        puts Executor::Exec.sh("service awslogs stop")
    end
    
  end
end
