#!/usr/bin/env bash
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

set -xe

/opt/elasticbeanstalk/bin/log-conf   -n httpd -l'/var/log/httpd/*' -f /opt/elasticbeanstalk/support/conf/httpd/apache_rotate_logs.conf
/opt/elasticbeanstalk/bin/log-conf   -n webapp -l'/var/app/support/logs/*'

# Remove the 'generic' log rotation configuration in favor of the beanstalk managed one
rm -f /etc/logrotate.d/httpd
