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
EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_staging_dir)
EB_APP_LOGS_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_logs_dir)

cd $EB_APP_STAGING_DIR

chown -R $EB_APP_USER:$EB_APP_USER $EB_APP_BASE_DIR
chown -R $EB_APP_USER:$EB_APP_USER /var/log/httpd

# If the user is using Symfony, then fix permissions
if [ -f app/SymfonyRequirements.php ]; then
  echo 'Ensuring that Symfony2 cache and log dir are writable by webapp'

  setfacl -R -m u:$EB_APP_USER:rwx -m u:root:rwx app/cache app/logs
  setfacl -dR -m u:$EB_APP_USER:rwx -m u:root:rwx app/cache app/logs

  chmod -R 1755 ./app/{cache,logs}
fi
