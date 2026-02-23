# Terraform module for IdP ID Sync ECS scheduled task

This module is used to create an ECS task running the id-sync component which syncs identities from a personnel
store.

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/070-id-sync) for usage documentation.

## What this does

 - Create task definition and scheduled ECS task

## Usage Example

```hcl
module "idsync" {
  source  = "sil-org/idp/aws//modules/070-id-sync"
  version = "~> 14.0" # This version number is an example only. Use the latest available."

  memory                      = var.memory
  cpu                         = var.cpu
  app_name                    = var.app_name
  app_env                     = var.app_env
  alb_https_listener_arn      = data.terraform_remote_state.cluster.alb_https_listener_arn
  cloudwatch_log_group_name   = var.cloudwatch_log_group_name
  docker_image                = data.terraform_remote_state.ecr.ecr_repo_idsync
  id_broker_access_token      = data.terraform_remote_state.broker.access_token_idsync
  id_broker_adapter           = var.id_broker_adapter
  id_broker_assertValidIp     = var.id_broker_assertValidIp
  id_broker_base_url          = "https://${data.terraform_remote_state.broker.hostname}"
  id_broker_trustedIpRanges   = data.terraform_remote_state.cluster.private_subnet_cidr_blocks
  id_store_adapter            = var.id_store_adapter
  id_store_config             = var.id_store_config
  idp_name                    = var.idp_name
  idp_display_name            = var.idp_display_name
  ecs_cluster_id              = data.terraform_remote_state.core.ecs_cluster_id
  alerts_email                = var.alerts_email
  notifier_email_to           = var.notifier_email_to
  allow_empty_email           = var.allow_empty_email
}
```
