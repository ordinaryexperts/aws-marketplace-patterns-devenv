#!/usr/bin/env bash

cd /code

if [ "$#" -ne 1 ]; then
    VERSION=`git describe`
else
    VERSION=$1
fi

cd /code

PATTERN=`ls cdk/*/*_stack.py | cut -d/ -f 2`
aws s3 cp /code/diagram.pngdist/template.yaml \
	s3://ordinary-experts-aws-marketplace-pattern-artifacts/$PATTERN/$VERSION/diagram.png \
	--acl public-read
echo "Copied to https://ordinary-experts-aws-marketplace-pattern-artifacts.s3.amazonaws.com/$PATTERN/$VERSION/template.yaml"
