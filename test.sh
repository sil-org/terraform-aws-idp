#!/usr/bin/env bash

set -e

echo "::group:: 010-cluster"
terraform -chdir=modules/010-cluster/ init
terraform -chdir=modules/010-cluster/ test -verbose
echo "::endgroup::"

echo "::group:: 032-db-backup"
terraform -chdir=modules/032-db-backup/ init
terraform -chdir=modules/032-db-backup/ test -verbose
echo "::endgroup::"

echo "::group:: 040-id-broker"
terraform -chdir=modules/040-id-broker/ init
terraform -chdir=modules/040-id-broker/ test -verbose
echo "::endgroup::"

echo "::group:: 050-pw-manager"
terraform -chdir=modules/050-pw-manager/ init
terraform -chdir=modules/050-pw-manager/ test -verbose
echo "::endgroup::"

echo "::group:: 060-simplesamlphp"
terraform -chdir=modules/060-simplesamlphp/ init
terraform -chdir=modules/060-simplesamlphp/ test -verbose
echo "::endgroup::"

echo "::group:: 070-id-sync"
terraform -chdir=modules/070-id-sync/ init
terraform -chdir=modules/070-id-sync/ test -verbose
echo "::endgroup::"
