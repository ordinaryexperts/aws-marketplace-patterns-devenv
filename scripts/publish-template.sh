#!/usr/bin/env bash

cd /code

if [ "$#" -ne 1 ]; then
    VERSION=`git describe`
else
    VERSION=$1
fi

# Defaults preserved for repos without marketplace_config.yaml
BUCKET="ordinary-experts-aws-marketplace-pattern-artifacts"
PATTERN=`ls cdk/*/*_stack.py | cut -d/ -f 2`

# If marketplace_config.yaml is present, let it override the bucket/pattern.
# This keeps marketplace.py (which reads the same config) and this script in sync.
if [ -f /code/marketplace_config.yaml ]; then
    CFG_BUCKET=$(python3 -c "import yaml; c=yaml.safe_load(open('/code/marketplace_config.yaml')); print(c.get('template_bucket') or '')" 2>/dev/null || echo "")
    CFG_PATTERN=$(python3 -c "import yaml; c=yaml.safe_load(open('/code/marketplace_config.yaml')); print(c.get('template_pattern') or '')" 2>/dev/null || echo "")
    if [ -n "$CFG_BUCKET" ]; then BUCKET="$CFG_BUCKET"; fi
    if [ -n "$CFG_PATTERN" ]; then PATTERN="$CFG_PATTERN"; fi
fi

mkdir -p /code/dist
cd /code/cdk
TEMPLATE_VERSION=$VERSION cdk synth \
    --version-reporting false\
    --path-metadata false \
    --asset-metadata false > /code/dist/template.yaml
cd /code

aws s3 cp /code/dist/template.yaml \
	s3://$BUCKET/$PATTERN/$VERSION/template.yaml \
	--acl public-read
echo "Copied to https://$BUCKET.s3.amazonaws.com/$PATTERN/$VERSION/template.yaml"
