#!/bin/bash -e
#==============================================================================
# Copyright 2014 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Amazon Software License (the "License"). You may not use
# this file except in compliance with the License. A copy of the License is
# located at
#
#       http://aws.amazon.com/asl/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, express or
# implied. See the License for the specific language governing permissions
# and limitations under the License.
#==============================================================================
set -ex

# only install and config CW logs for Amazon Linux
if grep -iq "Amazon Linux" /etc/issue
then
    yum install -y awslogs

    #
    # Overwrite the default config file so that the default log group defined in
    # the default config file will be removed and will not be created automatically
    #
    cat <<"EOF" > /etc/awslogs/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state
EOF

    region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
    sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

fi

/opt/elasticbeanstalk/bin/log-conf -n awslogs -l"/var/log/awslogs.log"
