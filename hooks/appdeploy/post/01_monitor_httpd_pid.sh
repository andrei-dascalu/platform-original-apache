#!/bin/bash

set -xe

chmod 0755 /var/run/httpd
/opt/elasticbeanstalk/bin/healthd-track-pidfile --proxy httpd
