#!/usr/bin/env bash

cd /code

if [ "$#" -ne 1 ]; then
    VERSION=`git config --global --add safe.directory /code && git describe --always`
else
    VERSION=$1
    IS_RELEASE=true
fi

rm -f manifest.json
VERSION=$VERSION packer build packer/ami.json

if [ -f /code/supported_regions.txt ]; then
    readarray -t supported_regions < /code/supported_regions.txt
else
    supported_regions=(
        "af-south-1"
        "ap-east-1"
        "ap-northeast-1"
        "ap-northeast-2"
        "ap-northeast-3"
        "ap-south-1"
        "ap-southeast-1"
        "ap-southeast-2"
        "ap-southeast-3"
        "ca-central-1"
        "eu-central-1"
        "eu-central-2"
        "eu-north-1"
        "eu-south-1"
        "eu-south-2"
        "eu-west-1"
        "eu-west-2"
        "eu-west-3"
        "me-central-1"
        "me-south-1"
        "sa-east-1"
        "us-east-1"
        "us-east-2"
        "us-west-1"
        "us-west-2"
    )
fi

if [ -f manifest.json ]; then

    AMI_ID=`cat manifest.json | jq -r .builds[0].artifact_id |  cut -d':' -f2`
    AMI_NAME=`aws ec2 describe-images --image-ids $AMI_ID | jq -r '.Images[].Name'`

    if [[ "$IS_RELEASE" = true ]]; then
        mapping_code="# AMI list generated by:\n"
        mapping_code+="# make TEMPLATE_VERSION=$VERSION ami-ec2-build\n"
        mapping_code+="# on $(date).\n"
        mapping_code+="AMI_ID=\"$AMI_ID\"\n"
        mapping_code+="AMI_NAME=\"$AMI_NAME\"\n"
        mapping_code+="generated_ami_ids = {\n"
        for i in ${!supported_regions[@]}; do
            region=${supported_regions[$i]}
            if [[ "$region" != "us-east-1" ]]; then
                mapping_code+="    \"$region\": \"ami-XXXXXXXXXXXXXXXXX\",\n"
            fi
        done
        mapping_code+="    \"us-east-1\": \"$AMI_ID\"\n"
        mapping_code+="}\n# End generated code block.\n\n"
        echo "All done generating image!"
        echo -e "Copy the below code into jitsi_stack.py where indicated:\n"
        echo -e "$mapping_code"
    fi
else
    echo "Error: no manifest.json found - cannot generate code snippet!"
fi

cd -
