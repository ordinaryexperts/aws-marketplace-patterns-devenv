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

if [ -f /code/marketplace_config.yaml ]; then
    CFG_BUCKET=$(python3 -c "import yaml; c=yaml.safe_load(open('/code/marketplace_config.yaml')); print(c.get('template_bucket') or '')" 2>/dev/null || echo "")
    CFG_PATTERN=$(python3 -c "import yaml; c=yaml.safe_load(open('/code/marketplace_config.yaml')); print(c.get('template_pattern') or '')" 2>/dev/null || echo "")
    if [ -n "$CFG_BUCKET" ]; then BUCKET="$CFG_BUCKET"; fi
    if [ -n "$CFG_PATTERN" ]; then PATTERN="$CFG_PATTERN"; fi
fi

aws s3 cp /code/diagram.png \
	s3://$BUCKET/$PATTERN/$VERSION/diagram.png \
	--acl public-read
echo "Copied to https://$BUCKET.s3.amazonaws.com/$PATTERN/$VERSION/diagram.png"
