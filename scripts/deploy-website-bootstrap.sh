#!/bin/bash

set -euo pipefail

domain="${1:-}"

if [[ -z "${domain}" ]]; then
  echo "USAGE: ${0} example.com" >&2
  exit 1
fi

name_safe_domain="${domain//./}"
stack_name="httphostdev-website-${name_safe_domain}-bootstrap"

aws cloudformation deploy \
  --parameter-overrides \
      "ApexDomain=${domain}" \
  --stack-name    "${stack_name}" \
  --tags \
      "httphost.dev:domain=${domain}" \
  --template-file ./cloudformation/website-bootstrap.cf.yaml

echo
echo "IMPORTANT: Update the name servers of ${domain} to:"
echo

aws cloudformation describe-stacks \
  --output     text \
  --query      "Stacks[0].Outputs[?(@.OutputKey == 'NameServers')] | [0].OutputValue" \
  --stack-name "${stack_name}"
