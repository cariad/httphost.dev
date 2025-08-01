#!/bin/bash

set -euo pipefail

domain="${1:-}"

if [[ -z "${domain}" ]]; then
  echo "USAGE: ${0} example.com" >&2
  exit 1
fi

name_safe_domain="${domain//./}"
stack_name_prefix="httphostdev-website-${name_safe_domain}"
global_stack_name="${stack_name_prefix}-global"

hosted_zone_id=$(
  aws route53 list-hosted-zones \
    --output text \
    --query  "HostedZones[?(@.Name == '${domain}.')] | [0].Id"
)

hosted_zone_id="${hosted_zone_id##*/}"

aws cloudformation deploy \
  --parameter-overrides "ApexDomain=${domain}" \
                        "HostedZoneId=${hosted_zone_id}" \
  --stack-name          "${global_stack_name}" \
  --tags                "httphost.dev:domain=${domain}" \
  --template-file       ./cloudformation/website-global.cf.yaml \
  --region              us-east-1

certificate_arn=$(
  aws cloudformation describe-stacks \
    --output     text \
    --query      "Stacks[0].Outputs[?(@.OutputKey == 'CertificateArn')] | [0].OutputValue" \
    --region     us-east-1 \
    --stack-name "${global_stack_name}"
)

aws cloudformation deploy \
  --parameter-overrides "ApexDomain=${domain}" \
                        "CertificateArn=${certificate_arn}" \
  --stack-name          "${stack_name_prefix}-regional" \
  --tags                "httphost.dev:domain=${domain}" \
  --template-file       ./cloudformation/website-regional.cf.yaml
