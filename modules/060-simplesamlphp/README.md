# Terraform module for IdP SimpleSAMLphp ECS service

This module is used to create an ECS service running [SimpleSAMLphp](https://simplesamlphp.org).

## What this does

 - Create ALB target group for SSP with hostname based routing
 - Create task definition and ECS service for SimpleSAMLphp
 - Create Cloudflare DNS records for SSP

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/060-simplesamlphp) for usage documentation.

## Usage Example

```hcl
module "ssp" {
  source  = "sil-org/idp/aws//modules/060-simplesamlphp"
  version = "~> 14.0" # This version number is an example only. Use the latest available."

  memory                       = var.memory
  cpu                          = var.cpu
  desired_count                = var.desired_count
  app_name                     = var.app_name
  app_env                      = var.app_env
  vpc_id                       = data.terraform_remote_state.cluster.vpc_id
  alb_https_listener_arn       = data.terraform_remote_state.cluster.alb_https_listener_arn
  subdomain                    = var.ssp_subdomain
  cloudflare_domain            = var.cloudflare_domain
  cloudwatch_log_group_name    = var.cloudwatch_log_group_name
  docker_image                 = data.terraform_remote_state.ecr.ecr_repo_simplesamlphp
  password_change_url          = "https://${data.terraform_remote_state.pwmanager.ui_hostname}/#/password/create"
  password_forgot_url          = "https://${data.terraform_remote_state.pwmanager.ui_hostname}/#/password/forgot"
  hub_mode                     = var.hub_mode
  id_broker_access_token       = data.terraform_remote_state.broker.access_token_ssp
  id_broker_assert_valid_ip    = var.id_broker_assert_valid_ip
  id_broker_base_uri           = "https://${data.terraform_remote_state.broker.hostname}"
  id_broker_trusted_ip_ranges  = data.terraform_remote_state.cluster.private_subnet_cidr_blocks
  mfa_learn_more_url           = var.mfa_learn_more_url
  mfa_setup_url                = var.mfa_setup_url
  db_name                      = var.db_ssp_name
  mysql_host                   = data.terraform_remote_state.database.rds_address
  mysql_user                   = var.db_ssp_user
  profile_url                  = var.profile_url
  recaptcha_key                = var.recaptcha_key
  recaptcha_secret             = var.recaptcha_secret
  remember_me_secret           = var.remember_me_secret
  ecs_cluster_id               = data.terraform_remote_state.core.ecs_cluster_id
  ecsServiceRole_arn           = data.terraform_remote_state.core.ecsServiceRole_arn
  task_execution_role_arn      = data.terraform_remote_state.core.task_execution_role_arn
  alb_dns_name                 = data.terraform_remote_state.cluster.alb_dns_name
  idp_name                     = var.idp_name
  theme_color_scheme           = var.theme_color_scheme
  trusted_ip_addresses = concat(
    var.trusted_ip_addresses,
    data.terraform_remote_state.cluster.outputs.public_subnet_cidr_blocks,
  )
  analytics_id                 = var.analytics_id
  show_saml_errors             = var.show_saml_errors
  help_center_url              = data.terraform_remote_state.broker.help_center_url
  enable_debug                 = var.enable_debug
  logging_level                = var.logging_level
}
```
