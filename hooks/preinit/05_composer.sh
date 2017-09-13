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

. /opt/elasticbeanstalk/support/envvars

EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config  container -k app_user)

# Set COMPOSER_HOME so that Composer is happy
export COMPOSER_HOME=/root

ln -sf /opt/elasticbeanstalk/support/composer.phar /usr/bin/composer.phar
chown $EB_APP_USER /usr/bin/composer.phar
chmod +x /usr/bin/composer.phar
