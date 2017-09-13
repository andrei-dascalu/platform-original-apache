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

EB_APP_STAGING_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_staging_dir)

cd $EB_APP_STAGING_DIR

if [ -f composer.json ]; then
  # Set COMPOSER_HOME so that Composer is happy
  export COMPOSER_HOME=/root
  if [ -d vendor ]; then
    echo 'Found a composer.json file, but not installing because a vendor folder is present.'
  else
    PHP_COMPOSER_OPTIONS=$(/opt/elasticbeanstalk/bin/get-config  optionsettings -n aws:elasticbeanstalk:container:php:phpini -o composer_options)
    echo 'Found composer.json file. Attempting to install vendors.'
    composer.phar install --no-ansi --no-interaction $PHP_COMPOSER_OPTIONS
  fi
else
  echo 'No composer.json file detected'
fi
