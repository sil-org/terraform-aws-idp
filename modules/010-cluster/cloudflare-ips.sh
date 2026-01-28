#!/usr/bin/env bash

set -e

curl --silent --fail 'https://api.cloudflare.com/client/v4/ips' | jq '{
  ipv4_cidrs: (.result.ipv4_cidrs | join(",")),
  ipv6_cidrs: (.result.ipv6_cidrs | join(","))
}'
