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

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_deploy_dir)
EB_APP_SUPPORT_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_support_dir)

mkdir -p $EB_APP_DEPLOY_DIR $EB_APP_SUPPORT_DIR/{logs,pids,assets}
