# Terraform module for IdP ID Sync ECS scheduled task

This module is used to create an ECS task running the id-sync component which syncs identities from a personnel
store.

## What this does

 - Create task definition and scheduled ECS task

## Required Inputs

 - `app_name` - Application name
 - `app_env` - Application environment
 - `cloudwatch_log_group_name` - CloudWatch log group name
 - `docker_image` - URL to Docker image
 - `id_broker_access_token` - Access token for calling id-broker
 - `id_broker_adapter` - Which ID Sync adapter to use
 - `id_broker_base_url` - Base URL to id-broker API
 - `id_broker_trustedIpRanges` - List of valid IP address ranges for ID Broker API
 - `id_store_adapter` - Which ID Store adapter to use
 - `id_store_config` - A map of configuration data to pass into id-sync as env vars
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `idp_display_name` - Friendly name for IdP
 - `ecs_cluster_id` - ID for ECS Cluster
 - `ecsServiceRole_arn` - ARN for ECS Service Role
 - `memory` - Amount of memory to allocate to container
 - `cpu` - Amount of CPU to allocate to container

## Optional Inputs

- `email_service_assertValidIp` - Whether or not to assert IP address for Email Service API is trusted
- `id_broker_assertValidIp` - Whether or not to assert IP address for ID Broker API is trusted
- `alerts_email` - Who to send alerts to about sync problems
- `notifier_email_to` - Who to send notifications to about sync problems (e.g. users lacking email addresses)
- `sync_safety_cutoff` - The percentage of records allowed to be changed during a sync, provided as a float, ex: `0.2` for `20%`
- `allow_empty_email` - Whether or not to allow the primary email property to be empty. Default: `false`
- `enable_new_user_notification` - Enable email notification to HR Contact upon creation of a new user, if set to 'true'. Default: `false`
- `enable_sync` - Set to false to disable the sync process.
- `sentry_dsn` - Sentry DSN for error logging and alerting. Obtain from Sentry dashboard: Settings - Projects - (project) - Client Keys
- `event_schedule` - AWS Cloudwatch schedule for the sync task. Use cron format "cron(Minutes Hours Day-of-month Month Day-of-week Year)" where either `day-of-month` or `day-of-week` must be a question mark, or rate format "rate(15 minutes)". Default = "cron(*/15 * * * ? *)"
- `heartbeat_url` - the URL of a monitoring service to call after every successful sync
- `heartbeat_method` - the http method of a monitoring service to call after every successful sync. Uses POST if not specified.

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
