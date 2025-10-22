# Terraform module for Password Manager API ECS service

This module is used to create an ECS service running the password manager API.

The password manager UI can be deployed using the [silinternatonal/pages/cloudflare](https://registry.terraform.io/modules/silinternational/pages/cloudflare/latest) module.

## What this does

 - Create ALB target group for API with hostname based routing
 - Create task definition and ECS service for password manager API service
 - Create Cloudflare DNS record for the API service

## Required Inputs

 - `alb_dns_name` - DNS name for application load balancer
 - `alb_https_listener_arn` - ARN for ALB HTTPS listener
 - `api_subdomain` - Subdomain for pw manager api
 - `app_env` - Application environment
 - `app_name` - Application name
 - `auth_saml_checkResponseSigning`  - true/false whether to check response for signature. Default: `true`
 - `auth_saml_idpCertificate` - Public cert contents for IdP 
 - `auth_saml_requireEncryptedAssertion` - true/false whether to require assertion to be encrypted. Default: `true`
 - `auth_saml_signRequest` - true/false whether to sign auth requests. Default: `true`
 - `auth_saml_spCertificate` - Public cert contents for this SP
 - `auth_saml_spPrivateKey` - Private cert contents for this SP
 - `cloudflare_domain` - Top level domain name for use with Cloudflare
 - `cloudwatch_log_group_name` - CloudWatch log group name
 - `cpu` - Amount of CPU to allocate to API container
 - `db_name` - Name of MySQL database for pw-api
 - `desired_count` - Number of API tasks that should be run
 - `docker_image` - URL to Docker image
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `email_signature` - Email signature line
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_assertValidBrokerIp` - Whether or not to assert IP address for ID Broker API is trusted. Default: `true`
 - `id_broker_base_uri` - Base URL to id-broker API
 - `id_broker_validIpRanges` - List of valid IP blocks for ID Broker
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `memory` - Amount of memory to allocate to API container
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password for id-broker
 - `mysql_user` - MySQL username for id-broker
 - `recaptcha_key` - Recaptcha site key
 - `recaptcha_secret` - Recaptcha secret
 - `support_email` - Email address for end user support
 - `support_name` - Name for end user support
 - `ui_subdomain` - Subdomain for PW UI
 - `vpc_id` - ID for VPC

## Optional Inputs

 - `alerts_email` - Email address to send alerts/notifications. Must be specified if `alerts_email_enabled` is `true`. Default: `""`
 - `alerts_email_enabled` - Enable or disabled alert notification emails. Default: `true`
 - `code_length` - Number of digits in reset code. Default: `"6"`
 - `create_dns_record` - Controls creation of a DNS CNAME record for the ECS service. Default: `true`
 - `extra_hosts` - Extra hosts for the API task definition, e.g. "\["hostname":"host.example.com","ipAddress":"192.168.1.1"\]"
 - `password_rule_enablehibp` - Enable haveibeenpwned.com password check. Default: `true`
 - `password_rule_maxlength` - Maximum password length. Default: `"255"`
 - `password_rule_minlength` - Minimum password length. Default: `"10"`
 - `password_rule_minscore` - Minimum password score. Default: `"3"`
 - `sentry_dsn` - Sentry DSN for error logging and alerting. Obtain from Sentry dashboard: Settings - Projects - (project) - Client Keys
 - `support_phone` - Phone number for end user support, displayed on PW UI.
 - `support_url` - URL for end user support, displayed on PW UI.

## Output

 - `ui_hostname` - Full hostname for UI

## Usage Example

```hcl
module "pwmanager" {
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
  mysql_pass                          = data.terraform_remote_state.database.db_pwmanager_pass
  mysql_user                          = var.mysql_user
  password_rule_enablehibp            = var.password_rule_enablehibp
  password_rule_maxlength             = var.password_rule_maxlength
  password_rule_minlength             = var.password_rule_minlength
  password_rule_minscore              = var.password_rule_minscore
  recaptcha_key                       = var.recaptcha_key
  recaptcha_secret                    = var.recaptcha_secret
  source                              = "github.com/silinternational/idp-in-a-box//terraform/050-pw-manager"
  support_email                       = data.terraform_remote_state.broker.support_email
  support_name                        = data.terraform_remote_state.broker.support_name
  support_phone                       = var.support_phone
  support_url                         = var.support_url
  ui_subdomain                        = var.ui_subdomain
  vpc_id                              = data.terraform_remote_state.cluster.vpc_id
}
```
