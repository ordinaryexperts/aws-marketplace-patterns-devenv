#!/usr/bin/env bash

echo "$(date): Starting setup-env.sh"

export CDK_CLI_VERSION=2.1032.0
export CDK_LIB_VERSION=2.225.0
export PACKER_VERSION=1.14.3
export TASKCAT_VERSION=0.9.57

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
pip3 install --break-system-packages -q taskcat==$TASKCAT_VERSION
# Note: taskcat 0.9.41 requires requests>=2.31.0
# Removed requests downgrade as it conflicts with taskcat requirements

# For scripts/pfl.py
pip3 install --break-system-packages -q \
     openpyxl   \
     pystache   \
     pyyaml

# Integration testing tools (requests already installed above for taskcat).
# Kept separate from optional AI dev tools below because pip install is
# atomic per invocation — if a single dep fails to resolve, none of the
# packages in the batch get installed.
pip3 install --break-system-packages -q \
     pytest==7.4.3          \
     pytest-asyncio==0.21.1 \
     pytest-timeout==2.2.0  \
     playwright==1.40.0     \
     boto3==1.34.16

# Optional AI dev tools — best-effort. goose-ai has no Python 3.12 release
# (all versions pin <3.12) so it will fail on Ubuntu 24.04, but we don't
# want that to block the test infrastructure or other tools above.
pip3 install --break-system-packages -q \
     aider-chat             \
     'langfuse<3.0,>=2.60'  \
     || echo "WARN: optional AI dev tools install failed (non-blocking)"
pip3 install --break-system-packages -q goose-ai \
     || echo "WARN: goose-ai install failed (no Python 3.12 release; non-blocking)"

# Install Playwright browsers (chromium only for smaller image).
# Note: cannot use `playwright install --with-deps chromium` on Ubuntu 24.04 —
# it tries to install `libasound2` which was renamed to `libasound2t64` in
# 24.04, causing the install to fail silently (exit 100) and leaving the
# image without chromium. Install the system deps explicitly first, then
# fetch the browser binary without --with-deps.
apt-get -y -q install --no-install-recommends \
    libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libdrm2 \
    libxkbcommon0 libatspi2.0-0 libxcomposite1 libxdamage1 \
    libxfixes3 libxrandr2 libgbm1 libasound2t64
playwright install chromium

# more recent nodejs
curl -sL https://deb.nodesource.com/setup_20.x | bash -
apt-get -y -q install nodejs

# cdk
npm install -g aws-cdk-lib@$CDK_LIB_VERSION
npm install -g aws-cdk@$CDK_CLI_VERSION

# packer
wget -q -O /tmp/packer.zip https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_${PACKER_VERSION}_linux_amd64.zip
unzip /tmp/packer.zip -d /usr/local/bin/
rm /tmp/packer.zip
packer plugins install github.com/hashicorp/amazon v1.2.9

echo "$(date): Finished setup-env.sh"
