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

# taskcat
apt-get -y -q install python3 python3-pip
pip3 install -q taskcat==$TASKCAT_VERSION
# https://github.com/docker/docker-py/issues/3113#issuecomment-1531621678
pip3 uninstall requests
pip3 install requests==2.28.1

# For scripts/pfl.py
pip3 install -q \
     openpyxl   \
     pystache   \
     pyyaml

# more recent nodejs
curl -sL https://deb.nodesource.com/setup_18.x | bash -
apt-get -y -q install nodejs

# cdk
npm install -g aws-cdk@$CDK_VERSION

# packer
wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip
unzip /tmp/packer.zip -d /usr/local/bin/
rm /tmp/packer.zip
packer plugins install github.com/hashicorp/amazon v1.2.9

echo "$(date): Finished setup-env.sh"
