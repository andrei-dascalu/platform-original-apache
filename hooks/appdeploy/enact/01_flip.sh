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

EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_staging_dir)
EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_deploy_dir)

if [ -d $EB_APP_DEPLOY_DIR ]; then
  mv $EB_APP_DEPLOY_DIR $EB_APP_DEPLOY_DIR.old
fi

mv $EB_APP_STAGING_DIR $EB_APP_DEPLOY_DIR

nohup rm -rf $EB_APP_DEPLOY_DIR.old >/dev/null 2>&1 &
