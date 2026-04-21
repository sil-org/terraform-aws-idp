# Terraform module for IdP ID Broker ECS service

This module is used to create an ECS service running idp-id-broker.

## What this does

 - Create internal ALB for idp-broker
 - Create task definition and ECS service for id-broker
 - Create Cloudflare DNS record

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/040-id-broker) for usage documentation.

## Usage Example

```hcl
module "broker" {
  source  = "sil-org/idp/aws//modules/040-id-broker"
  version = "~> 14.0" # This version number is an example only. Use the latest available."

  app_env                          = var.app_env
  app_name                         = var.app_name
  cloudflare_domain                = var.cloudflare_domain
  cloudwatch_log_group_name        = var.cloudwatch_log_group_name
  contingent_user_duration         = var.contingent_user_duration
  cpu                              = var.cpu
  cpu_cron                         = var.cpu_cron
  db_name                          = var.db_name
  desired_count                    = var.desired_count
  docker_image                     = data.terraform_remote_state.ecr.ecr_repo_idbroker
  email_repeat_delay_days          = var.email_repeat_delay_days
  ecs_cluster_id                   = data.terraform_remote_state.core.ecs_cluster_id
  ecsServiceRole_arn               = data.terraform_remote_state.core.ecsServiceRole_arn
  email_signature                  = var.email_signature
  event_schedule                   = "cron(1 0 * * ? 0)"
  google_config                    = var.google_config
  help_center_url                  = var.help_center_url
  hibp_check_interval              = var.hibp_check_interval
  hibp_check_on_login              = var.hibp_check_on_login
  hibp_grace_period                = var.hibp_grace_period
  hibp_tracking_only               = var.hibp_tracking_only
  hibp_notification_bcc            = var.hibp_notification_bcc
  idp_display_name                 = var.idp_display_name
  idp_name                         = var.idp_name
  inactive_user_period             = var.inactive_user_period
  inactive_user_deletion_enable    = var.inactive_user_deletion_enable
  internal_alb_dns_name            = data.terraform_remote_state.cluster.internal_alb_dns_name
  internal_alb_listener_arn        = data.terraform_remote_state.cluster.internal_alb_https_listener_arn
  invite_email_delay_seconds       = var.invite_email_delay_seconds
  invite_grace_period              = var.invite_grace_period
  invite_lifespan                  = var.invite_lifespan
  lost_security_key_email_days     = var.lost_security_key_email_days
  memory                           = var.memory
  memory_cron                      = var.memory_cron
  method_codeLength                = var.method_codeLength
  method_gracePeriod               = var.method_gracePeriod
  method_lifetime                  = var.method_lifetime
  method_maxAttempts               = var.method_maxAttempts
  mfa_allow_disable                = var.mfa_allow_disable
  mfa_lifetime                     = var.mfa_lifetime
  mfa_manager_bcc                  = var.mfa_manager_bcc
  mfa_manager_help_bcc             = var.mfa_manager_help_bcc
  mfa_required_for_new_users       = var.mfa_required_for_new_users
  mfa_totp_apibaseurl              = var.mfa_totp_apibaseurl
  mfa_webauthn_apibaseurl          = var.mfa_webauthn_apibaseurl
  rp_origins                       = var.rp_origins
  minimum_backup_codes_before_nag  = var.minimum_backup_codes_before_nag
  mysql_host                       = data.terraform_remote_state.database.rds_address
  mysql_user                       = var.mysql_user
  notification_email               = var.notification_email
  password_expiration_grace_period = var.password_expiration_grace_period
  password_lifespan                = var.password_lifespan
  password_mfa_lifespan_extension  = var.password_mfa_lifespan_extension
  password_profile_url             = var.password_profile_url
  password_reuse_limit             = var.password_reuse_limit
  profile_review_interval          = var.profile_review_interval
  run_task                         = var.run_task
  send_get_backup_codes_emails     = var.send_get_backup_codes_emails
  send_invite_emails               = var.send_invite_emails
  send_lost_security_key_emails    = var.send_lost_security_key_emails
  send_method_purged_emails        = var.send_method_purged_emails
  send_method_reminder_emails      = var.send_method_reminder_emails
  send_mfa_disabled_emails         = var.send_mfa_disabled_emails
  send_mfa_enabled_emails          = var.send_mfa_enabled_emails
  send_mfa_option_added_emails     = var.send_mfa_option_added_emails
  send_mfa_option_removed_emails   = var.send_mfa_option_removed_emails
  send_mfa_rate_limit_emails       = var.send_mfa_rate_limit_emails
  send_password_changed_emails     = var.send_password_changed_emails
  send_password_expired_emails     = var.send_password_expired_emails
  send_password_expiring_emails    = var.send_password_expiring_emails
  send_refresh_backup_codes_emails = var.send_refresh_backup_codes_emails
  send_welcome_emails              = var.send_welcome_emails
  subdomain                        = var.broker_subdomain
  subject_for_get_backup_codes     = var.subject_for_get_backup_codes
  subject_for_invite               = var.subject_for_invite
  subject_for_lost_security_key    = var.subject_for_lost_security_key
  subject_for_method_purged        = var.subject_for_method_purged
  subject_for_method_reminder      = var.subject_for_method_reminder
  subject_for_method_verify        = var.subject_for_method_verify
  subject_for_mfa_disabled         = var.subject_for_mfa_disabled
  subject_for_mfa_enabled          = var.subject_for_mfa_enabled
  subject_for_mfa_manager          = var.subject_for_mfa_manager
  subject_for_mfa_manager_help     = var.subject_for_mfa_manager_help
  subject_for_mfa_option_added     = var.subject_for_mfa_option_added
  subject_for_mfa_option_removed   = var.subject_for_mfa_option_removed
  subject_for_mfa_rate_limit       = var.subject_for_mfa_rate_limit
  subject_for_password_changed     = var.subject_for_password_changed
  subject_for_password_expired     = var.subject_for_password_expired
  subject_for_password_expiring    = var.subject_for_password_expiring
  subject_for_refresh_backup_codes = var.subject_for_refresh_backup_codes
  subject_for_welcome              = var.subject_for_welcome
  support_email                    = var.support_email
  support_name                     = var.support_name
  vpc_id                           = data.terraform_remote_state.cluster.vpc_id
}
```
