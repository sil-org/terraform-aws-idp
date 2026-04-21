# Terraform module for Password Manager API ECS service

This module is used to create an ECS service running the password manager API.

The password manager UI can be deployed using the [sil-org/pages/cloudflare](https://registry.terraform.io/modules/sil-org/pages/cloudflare/latest) module.

## What this does

 - Create ALB target group for API with hostname based routing
 - Create task definition and ECS service for password manager API service
 - Create Cloudflare DNS record for the API service

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/050-pw-manager) for usage documentation.

## Usage Example

```hcl
module "pwmanager" {
  source  = "sil-org/idp/aws//modules/050-pw-manager"
  version = "~> 14.0" # This version number is an example only. Use the latest available."

  alb_dns_name                        = data.terraform_remote_state.cluster.alb_dns_name
  alb_https_listener_arn              = data.terraform_remote_state.cluster.alb_https_listener_arn
  alerts_email                        = var.alerts_email
  api_subdomain                       = var.api_subdomain
  app_env                             = var.app_env
  app_name                            = var.app_name
  auth_saml_checkResponseSigning      = var.auth_saml_checkResponseSigning
  auth_saml_idpCertificate            = var.auth_saml_idpCertificate
  auth_saml_requireEncryptedAssertion = var.auth_saml_requireEncryptedAssertion
  auth_saml_signRequest               = var.auth_saml_signRequest
  auth_saml_spCertificate             = var.auth_saml_spCertificate
  auth_saml_spPrivateKey              = var.auth_saml_spPrivateKey
  cloudflare_domain                   = var.cloudflare_domain
  cloudwatch_log_group_name           = var.cloudwatch_log_group_name
  code_length                         = var.code_length
  cpu                                 = var.cpu
  db_name                             = var.db_name
  desired_count                       = var.desired_count
  docker_image                        = data.terraform_remote_state.ecr.ecr_repo_pwapi
  ecs_cluster_id                      = data.terraform_remote_state.core.ecs_cluster_id
  ecsServiceRole_arn                  = data.terraform_remote_state.core.ecsServiceRole_arn
  email_signature                     = data.terraform_remote_state.broker.email_signature
  extra_hosts                         = var.extra_hosts
  help_center_url                     = data.terraform_remote_state.broker.help_center_url
  id_broker_access_token              = data.terraform_remote_state.broker.access_token_pwmanager
  id_broker_assertValidBrokerIp       = var.id_broker_assertValidBrokerIp
  id_broker_base_uri                  = "https://${data.terraform_remote_state.broker.hostname}"
  id_broker_validIpRanges             = data.terraform_remote_state.cluster.private_subnet_cidr_blocks
  idp_display_name                    = var.idp_display_name
  idp_name                            = var.idp_name
  memory                              = var.memory
  mysql_host                          = data.terraform_remote_state.database.rds_address
  mysql_user                          = var.mysql_user
  password_rule_enablehibp            = var.password_rule_enablehibp
  password_rule_maxlength             = var.password_rule_maxlength
  password_rule_minlength             = var.password_rule_minlength
  password_rule_minscore              = var.password_rule_minscore
  recaptcha_key                       = var.recaptcha_key
  recaptcha_secret                    = var.recaptcha_secret
  support_email                       = data.terraform_remote_state.broker.support_email
  support_name                        = data.terraform_remote_state.broker.support_name
  support_phone                       = var.support_phone
  support_url                         = var.support_url
  ui_subdomain                        = var.ui_subdomain
  vpc_id                              = data.terraform_remote_state.cluster.vpc_id
}
```
