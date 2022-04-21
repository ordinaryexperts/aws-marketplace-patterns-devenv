#!/usr/bin/env bash

cd /code/cdk
cdk synth > /code/test/main-test/template.yaml
cd /code/test/main-test
taskcat lint
