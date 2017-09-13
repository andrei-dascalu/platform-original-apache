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

EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config  container -k app_user)
EB_APP_BASE_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_base_dir)
EB_APP_LOGS_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_logs_dir)

chown -R $EB_APP_USER:$EB_APP_USER $EB_APP_BASE_DIR
chown -R $EB_APP_USER:$EB_APP_USER $EB_APP_LOGS_DIR

#ssh -i ~/.ssh/fuzzy-debian ubuntu@54.229.197.224
# /opt/elasticbeanstalk/hooks/preinit/01_setup_envvars.sh
