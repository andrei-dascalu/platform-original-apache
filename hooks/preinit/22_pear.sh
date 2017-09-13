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

function is_baked
{
  if [[ -f /etc/elasticbeanstalk/baking_manifest/$1 ]]; then
    true
  else
    false
  fi
}

if is_baked pear_packages; then
  echo PEAR packages have already been installed. Skipping installation.
  exit 0
fi

PHP_VERSION=$(/opt/elasticbeanstalk/bin/get-config container -k php_version)
if [ $PHP_VERSION == '7.0' ]; then
  yum install -y php7-pear
  ln -s /usr/bin/pear7 /usr/bin/pear
  echo `date -u` > /etc/elasticbeanstalk/baking_manifest/pear_packages
else
  # Install PEAR package
    yum install -y \
        php-channel-amazon \
        php-channel-ezc \
        php-channel-phpunit \
        php-channel-symfony \
        php-symfony-YAML
fi

# Configure PEAR so that extensions know where php.ini is and install properly
pear config-create /root /root/.pearrc
pear config-set php_ini /etc/php.ini user
pear config-set auto_discover 1 user
pear config-set php_ini /etc/php.ini system
pear config-set auto_discover 1 system

