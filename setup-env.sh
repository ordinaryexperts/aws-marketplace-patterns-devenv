#!/usr/bin/env bash

echo "$(date): Starting setup-env.sh"

export CDK_VERSION=2.120.0
export PACKER_VERSION=1.10.0
export TASKCAT_VERSION=0.9.41

# system upgrades and tools
export DEBIAN_FRONTEND=noninteractive
apt-get -y -q update && apt-get -y -q upgrade
apt-get -y -q install \
        curl  \
        git   \
        groff \
        jq    \
        less  \
        unzip \
        vim   \
        wget

# aws cli
cd /tmp
curl --silent --show-error https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip -q awscliv2.zip
./aws/install
cd -

# aws session manager plugin
cd /tmp
curl --silent --show-error "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb
cd -

# taskcat
apt-get -y -q install python3 python3-pip
pip3 install -q taskcat==$TASKCAT_VERSION
# Note: taskcat 0.9.41 requires requests>=2.31.0
# Removed requests downgrade as it conflicts with taskcat requirements

# For scripts/pfl.py
pip3 install -q \
     openpyxl   \
     pystache   \
     pyyaml

# Integration testing tools (requests already installed above for taskcat)
pip3 install -q \
     pytest==7.4.3          \
     pytest-asyncio==0.21.1 \
     pytest-timeout==2.2.0  \
     playwright==1.40.0     \
     boto3==1.34.16

# Install Playwright browsers (chromium only for smaller image)
playwright install --with-deps chromium

# more recent nodejs
curl -sL https://deb.nodesource.com/setup_20.x | bash -
apt-get -y -q install nodejs

# cdk
npm install -g aws-cdk@$CDK_VERSION

# packer
wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip
unzip /tmp/packer.zip -d /usr/local/bin/
rm /tmp/packer.zip
packer plugins install github.com/hashicorp/amazon v1.2.9

echo "$(date): Finished setup-env.sh"
