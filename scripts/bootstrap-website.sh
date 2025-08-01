#!/bin/bash

set -euo pipefail

domain="${1}"

safe_domain="${domain//./}"
stack_name="httphostdev-website-${safe_domain}-bootstrap"

aws cloudformation deploy \
  --parameter-overrides \
      "ApexDomain=${domain}" \
  --stack-name    "${stack_name}" \
  --template-file ./cloudformation/website-bootstrap.cf.yaml

echo
echo "IMPORTANT: Update the name servers of ${domain} to:"
echo

aws cloudformation describe-stacks \
  --output     text \
  --query      "Stacks[0].Outputs[?(@.OutputKey == 'NameServers')] | [0].OutputValue" \
  --stack-name "${stack_name}"
