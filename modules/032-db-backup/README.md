# Terraform module for a database backup service

This module is used to run mysqldump and backup files to S3 and optionally synchronized to Backblaze B2.

## What this does

 - Create an S3 bucket to store backups
 - Create a AWS backup user for script to use
 - Create task definition and scheduled event for db-backup
 - OPTIONAL: Synchronize the S3 backup to Backblaze B2

## Required Inputs

 - `app_env` - Application environment
 - `cloudwatch_log_group_name` - CloudWatch log group name
 - `docker_image` - The docker image to use for this
 - `ecs_cluster_id` - ID for ECS Cluster
 - `idp_name` - Short name of IdP for use in logs and email alerts
 - `mysql_host` - Address for RDS instance
 - `mysql_pass` - MySQL password
 - `mysql_user` - MySQL username

## Optional Inputs

 - `app_name` - Application name
 - `backup_user_name` - Name of IAM user for S3 access. Default: `db-backup-${var.idp_name}-${var.app_env}`
 - `cpu` - CPU resources to allot to each task instance
 - `event_schedule` - Schedule for backup task execution. Default: `cron(0 2 * * ? *)`
 - `delete_recovery_point_after_days` - Number of days after which AWS Backup recovery points are deleted. Default: 100
 - `db_names` - List of database names to backup. Default: `["emailservice", "idbroker", "pwmanager", "ssp"]`
 - `memory` - Memory (RAM) resources to allot to each task instance
 - `service_mode` - Either `backup` or `restore`. Default: `backup`
 - `enable_aws_backup` - Enable AWS Backup in addition to the scripted backup
 - `aws_backup_schedule` - Schedule for AWS Backup. Default: `"0 14 * * ? *"`
 - `aws_backup_notification_events` - List of events names to send to SNS. Default: `["BACKUP_JOB_FAILED"]`
 - `backup_sns_email` - Email address for backup event SNS subscription. Default: `""` (disabled)

## Usage Example

```hcl
module "dbbackup" {
  source                    = "github.com/silinternational/idp-in-a-box//terraform/032-db-backup"
  app_env                   = var.app_env
  app_name                  = var.app_name
  cloudwatch_log_group_name = var.cloudwatch_log_group_name
  cpu                       = var.cpu
  event_schedule            = var.event_schedule
  db_names                  = var.db_names
  docker_image              = data.terraform_remote_state.ecr.ecr_repo_dbbackup
  ecs_cluster_id            = data.terraform_remote_state.core.ecs_cluster_id
  idp_name                  = var.idp_name
  memory                    = var.memory
  mysql_host                = data.terraform_remote_state.database.rds_address
  mysql_pass                = data.terraform_remote_state.database.mysql_pass
  mysql_user                = data.terraform_remote_state.database.mysql_user
  service_mode              = var.service_mode
}
```
