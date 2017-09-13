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

if is_baked php_base_packages; then
  echo PHP base and related packages have already been installed. Skipping installation.
else
	yum install -y \
	    dos2unix \
	    gcc-c++ \
	    git-all \
	    libcurl-devel \
	    libxml2-devel \
	    libxslt-devel \
	    make \
	    mercurial \
	    mysql \
	    mysql-devel \
	    ruby-devel \
	    rubygem-json \
	    rubygems \
	    subversion \
	    tree
fi

PHP_VERSION=$(/opt/elasticbeanstalk/bin/get-config  container -k php_version)

case $PHP_VERSION in
  7.0)
        if is_baked php70_packages; then
          echo PHP 7.0 packages have already been installed. Skipping installation.
        else  
            echo "Configuring container for PHP 7.0"
            yum install -y \
                php70 \
                php70-bcmath \
                php70-cli \
                php70-common \
                php70-devel \
                php70-gd \
                php70-intl \
                php70-mbstring \
                php70-mcrypt \
                php70-mysqlnd \
                php70-odbc \
                php70-opcache \
                php70-pdo \
                php70-pecl-apcu \
                php70-pecl-imagick \
                php70-pecl-memcache \
                php70-pecl-memcached \
                php70-pecl-oauth \
                php70-pecl-ssh2 \
                php70-pgsql \
                php70-process \
                php70-soap \
                php70-xml \
                php70-xmlrpc \
                php70-pecl-uuid
    fi
    ;;
  5.6)
        if is_baked php56_packages; then
          echo PHP 5.6 packages have already been installed. Skipping installation.
        else  
            echo "Configuring container for PHP 5.6"
            yum install -y \
                php56 \
                php56-bcmath \
                php56-cli \
                php56-common \
                php56-devel \
                php56-gd \
                php56-intl \
                php56-mbstring \
                php56-mcrypt \
                php56-mysqlnd \
                php56-odbc \
                php56-opcache \
                php56-pdo \
                php56-pecl-apcu \
                php56-pecl-imagick \
                php56-pecl-memcache \
                php56-pecl-memcached \
                php56-pecl-oauth \
                php56-pecl-ssh2 \
                php56-pgsql \
                php56-process \
                php56-soap \
                php56-xml \
                php56-xmlrpc \
                uuid-php56
    fi
    ;;
  5.5)
		if is_baked php55_packages; then
		  echo PHP 5.5 packages have already been installed. Skipping installation.
		else  
			echo "Configuring container for PHP 5.5"
		    yum install -y \
		        php55 \
		        php55-bcmath \
		        php55-cli \
		        php55-common \
		        php55-devel \
		        php55-gd \
		        php55-intl \
		        php55-mbstring \
		        php55-mcrypt \
		        php55-mysqlnd \
		        php55-odbc \
		        php55-opcache \
		        php55-pdo \
		        php55-pecl-apcu \
		        php55-pecl-imagick \
		        php55-pecl-memcache \
		        php55-pecl-memcached \
		        php55-pecl-oauth \
		        php55-pecl-ssh2 \
		        php55-pgsql \
		        php55-process \
		        php55-soap \
		        php55-xml \
		        php55-xmlrpc \
		        uuid-php55
    fi
    ;;
  5.4)
    if is_baked php54_packages; then
      echo PHP 5.4 packages have already been installed. Skipping installation.
    else  
	    echo "Configuring container for PHP 5.4"
	    yum install -y \
	        php54-bcmath \
	        php54-cli \
	        php54-common \
	        php54-devel \
	        php54-gd \
	        php54-intl \
	        php54-mbstring \
	        php54-mcrypt \
	        php54-mysqlnd \
	        php54-odbc \
	        php54-pdo \
	        php54-pecl-apc \
	        php54-pecl-imagick \
	        php54-pecl-memcache \
	        php54-pecl-memcached \
	        php54-pecl-oauth \
	        php54-pecl-ssh2 \
	        php54-pgsql \
	        php54-process \
	        php54-soap \
	        php54-xml \
	        php54-xmlrpc \
	        uuid-php54
    fi
    ;;
  *)
  echo ERROR: PHP version $PHP_VERSION is not supported.
  exit 1
esac
