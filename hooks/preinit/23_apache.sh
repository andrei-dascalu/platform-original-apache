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

cp /opt/elasticbeanstalk/support/conf/httpd/httpd_upstart /etc/init/httpd.conf
cp /opt/elasticbeanstalk/support/conf/httpd/httpd_init /etc/init.d/httpd
chmod +x /etc/init.d/httpd

rm -rfv /var/www/html
ln -sfv /var/app/current /var/www/html

EB_APP_DEPLOY_DIR=$(/opt/elasticbeanstalk/bin/get-config  container -k app_deploy_dir)
PHP_DOCUMENT_ROOT=$(/opt/elasticbeanstalk/bin/get-config  optionsettings -n aws:elasticbeanstalk:container:php:phpini -o document_root)

mkdir -p $EB_APP_DEPLOY_DIR/$PHP_DOCUMENT_ROOT

# Use environment variables with Apache. Apache will source /etc/sysconfig/httpd
# before starting, and the variables exported in this file can be used directly
# in Apache configuration files. These variables will also be available to PHP
# using the $ENV[''] superglobal.
# See: http://serverfault.com/a/64663
grep -q '/opt/elasticbeanstalk/support/envvars' /etc/sysconfig/httpd || echo '. /opt/elasticbeanstalk/support/envvars' >> /etc/sysconfig/httpd

EB_APP_USER=$(/opt/elasticbeanstalk/bin/get-config  container -k app_user)

# Ensure that apache runs as the Beanstalk user
sed -i "s/User .*/User $EB_APP_USER/g" /etc/httpd/conf/httpd.conf
sed -i "s/Group .*/Group $EB_APP_USER/g" /etc/httpd/conf/httpd.conf

# Add PHP to the DirectoryIndex
sed -i 's/DirectoryIndex .*/DirectoryIndex index.php index.html/g' /etc/httpd/conf/httpd.conf

# Update the httpd.conf file to enable the use of .htaccess
sed -i 's/AllowOverride None/AllowOverride All/g' /etc/httpd/conf/httpd.conf

# Disable directory indexing
sed -i 's/Options Indexes FollowSymLinks/Options FollowSymLinks/g' /etc/httpd/conf/httpd.conf

# Configure Apache for AWS if it has not been already

if grep -q 'AWS Settings' /etc/httpd/conf/httpd.conf; then
  echo 'Apache is already configured'
else
    cat >> /etc/httpd/conf/httpd.conf <<END_OF_TEXT

#### AWS Settings ####

# Disable ETag headers
FileETag none

# Hide Apache and PHP info
Header unset Server
Header unset X-Powered-By

# Don't expose server versions
ServerSignature Off
ServerTokens Prod

# Enable server-status for internal IP
<Location /server-status>
   SetHandler server-status
   Require ip 127.0.0.1
</Location>

# KeepAlive: Whether or not to allow persistent connections (more than
# one request per connection). Set to "Off" to deactivate.
KeepAlive On
KeepAliveTimeout 65

# Configure /var/www/html
<Directory "/var/www/html">
    Options FollowSymLinks
    AllowOverride All
    DirectoryIndex index.html index.php
    Require all granted
</Directory>

# Add remote IP to log
LogFormat "%h (%{X-Forwarded-For}i) %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined

#### End of AWS Settings ####

END_OF_TEXT
fi

# Add better mime-types
cp /opt/elasticbeanstalk/support/conf/httpd/add-types.conf /etc/httpd/conf.d/add-types.conf

# Ensure that the timeout is greater than the default ELB timeout
cp /opt/elasticbeanstalk/support/conf/httpd/mod_reqtimeout.conf /etc/httpd/conf.d/mod_reqtimeout.conf

# Disable client specified proxy injection
cp /opt/elasticbeanstalk/support/conf/httpd/unset_proxy_header.conf /etc/httpd/conf.d/unset_proxy_header.conf

# Disable unused modules. If they don't exist, then that's fine because it 
# probably means this script has already run
mv /etc/httpd/conf.d/userdir.conf /etc/httpd/conf.d/userdir.conf.disabled 2>/dev/null || true
mv /etc/httpd/conf.modules.d/00-lua.conf /etc/httpd/conf.modules.d/00-lua.conf.disabled 2>/dev/null || true
mv /etc/httpd/conf.modules.d/00-dav.conf /etc/httpd/conf.modules.d/00-dav.conf.disabled 2>/dev/null || true
mv /etc/httpd/conf.modules.d/01-cgi.conf /etc/httpd/conf.modules.d/01-cgi.conf.disabled 2>/dev/null || true
# Disable unused config files, and again, allow them to fail silently if this 
# script has already run
mv /etc/httpd/conf.d/autoindex.conf /etc/httpd/conf.d/autoindex.conf.disable 2>/dev/null || true
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disable 2>/dev/null || true
