# AGENTS.md

This file provides guidance to coding agents like Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`terraform-aws-idp` is a Terraform module registry package (published as `sil-org/idp/aws` on the Terraform Registry) that provisions SIL's "IdP-in-a-Box" identity provider stack on AWS: an ECS cluster fronted by an ALB, running `idp-id-broker`, `idp-pw-api` (password manager), `SimpleSAMLphp`, `idp-id-sync`, and a MySQL backup task. Consumers pull individual submodules (not the whole repo) by path, e.g. `source = "sil-org/idp/aws//modules/040-id-broker"`.

## Module layout and load order

Submodules live under `modules/` and are numbered to indicate their dependency/deploy order:

- `010-cluster` — VPC, security groups, ASG, ACM cert lookup, ALB, CloudWatch log group. Foundation everything else depends on.
- `032-db-backup` — mysqldump-to-S3 (optionally synced to Backblaze B2) scheduled ECS task.
- `040-id-broker` — ECS service for `idp-id-broker`, internal ALB, Cloudflare DNS record. Has by far the largest variable surface (email/MFA/password-policy settings).
- `050-pw-manager` — ECS service for the password manager API (`idp-pw-api`); its UI is deployed separately via the `sil-org/pages/cloudflare` module.
- `060-simplesamlphp` — ECS service for SimpleSAMLphp.
- `070-id-sync` — scheduled ECS task for `idp-id-sync`, syncs identities from a personnel store.
- `ecs-role` — small shared internal module (not independently published/numbered) providing the ECS task IAM role; consumed via relative `source = "../ecs-role"` by `040-id-broker`, `050-pw-manager`, `060-simplesamlphp`, and `070-id-sync`.

Modules wire together via `terraform_remote_state` data sources in real usage (e.g. `050-pw-manager` reads `data.terraform_remote_state.broker.hostname`, `060-simplesamlphp` reads from `cluster`, `broker`, `pwmanager`, and `database` remote states). Each submodule's `variables.tf` and `output.tf` files document the data it shares with other modules.

## Commands

Terraform `~> 1.8`, AWS provider `~> 6.0` (per each module's `versions.tf`).

Run all module test suites (what CI's `tftest` job runs):

```bash
./test.sh
```

Run a single module's tests directly:

```bash
terraform -chdir=modules/010-cluster/ init
terraform -chdir=modules/010-cluster/ test -verbose
```

Tests are native Terraform tests (`modules/*/test.tftest.hcl`) using `mock_provider`/`mock_resource`/`mock_data` blocks — no real AWS credentials or apply needed to run them.

The `test/` directory at the repo root is a separate Terraform config that wires all submodules together (via relative `../modules/...` sources) purely to validate they compose — CI's `test` job (via `sil-org/workflows/.github/workflows/terraform.yml`) runs `init`/`validate`-style checks against it, not `apply`.

## Conventions

- Keep the numeric prefix ordering meaningful when adding a new submodule — it documents deploy/dependency order, not just naming.
- `README.md` in each submodule should stay in sync with its actual `variables.tf`/`outputs.tf` and the registry docs, but Terraform Registry generates documentation based on the actual Terraform files.
- When adding or changing a variable, add/update the corresponding `test.tftest.hcl` mocks and assertions rather than relying only on `terraform validate`.
