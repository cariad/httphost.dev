#!/bin/bash

set -euo pipefail

domain="${1:-}"

if [[ -z "${domain}" ]]; then
  echo "USAGE: ${0} example.com" >&2
  exit 1
fi

name_safe_domain="${domain//./}"
stack_name_prefix="httphostdev-website-${name_safe_domain}"

hosted_zone_id=$(
  aws route53 list-hosted-zones \
    --output text \
    --query  "HostedZones[?(@.Name == '${domain}.')] | [0].Id"
)

hosted_zone_id="${hosted_zone_id##*/}"

aws cloudformation deploy \
  --parameter-overrides "ApexDomain=${domain}" \
                        "HostedZoneId=${hosted_zone_id}" \
  --stack-name          "${stack_name_prefix}-global" \
  --tags                "httphost.dev:domain=${domain}" \
  --template-file       ./cloudformation/website-global.cf.yaml \
  --region              us-east-1

aws cloudformation deploy \
  --parameter-overrides "ApexDomain=${domain}" \
  --stack-name          "${stack_name_prefix}-regional" \
  --tags                "httphost.dev:domain=${domain}" \
  --template-file       ./cloudformation/website-regional.cf.yaml
