# Terraform module for a database backup service

This module is used to run mysqldump and backup files to S3 and optionally synchronized to Backblaze B2.

## What this does

 - Create an S3 bucket to store backups
 - Create a AWS backup user for script to use
 - Create task definition and scheduled event for db-backup
 - OPTIONAL: Synchronize the S3 backup to Backblaze B2

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/032-db-backup) for usage documentation.

## Usage Example

```hcl
module "dbbackup" {
  source  = "sil-org/idp/aws//modules/032-db-backup"
  version = "~> 14.0" # This version number is an example only. Use the latest available."
  
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
  mysql_user                = data.terraform_remote_state.database.mysql_user
  service_mode              = var.service_mode
}
```
