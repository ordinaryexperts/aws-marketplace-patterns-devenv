#!/usr/bin/env bash

cd /code

if [ "$#" -ne 1 ]; then
    VERSION=`git describe`
else
    VERSION=$1
fi

mkdir -p /code/dist
cd /code/cdk
TEMPLATE_VERSION=$VERSION cdk synth \
    --version-reporting false\
    --path-metadata false \
    --asset-metadata false > /code/dist/template.yaml
cd /code

PATTERN=`ls cdk/*/*_stack.py | cut -d/ -f 2`
aws s3 cp /code/dist/template.yaml \
	s3://ordinary-experts-aws-marketplace-pattern-artifacts/$PATTERN/$VERSION/template.yaml \
	--acl public-read
echo "Copied to https://ordinary-experts-aws-marketplace-pattern-artifacts.s3.amazonaws.com/$PATTERN/$VERSION/template.yaml"
