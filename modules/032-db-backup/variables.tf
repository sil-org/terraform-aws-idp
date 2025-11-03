variable "app_env" {
  description = "Application environment, ex: prod, stg, dev, etc."
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "db-backup"
}

variable "backup_user_name" {
  description = <<-EOT
    Name of IAM user for S3 access. If not specified: `db-backup-{var.idp_name}-{var.app_env}`
  EOT
  type        = string
  default     = null
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "cpu" {
  description = "CPU resources to allot to each task instance"
  type        = number
  default     = 32
}

variable "db_names" {
  description = "List of database names to back up."
  type        = list(string)
  default = [
    "idbroker",
    "pwmanager",
    "ssp",
  ]
}

variable "docker_image" {
  description = "The docker image to use for scheduled backup"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID of ECS Cluster to place the backup tasks"
  type        = string
}

variable "event_schedule" {
  description = <<-EOT
    Schedule for backup task execution. Use cron format "cron(Minutes Hours Day-of-month Month Day-of-week Year)"
    where either `day-of-month` or `day-of-week` must be a question mark, or rate format "rate(15 minutes)".
  EOT
  type        = string
  default     = "cron(0 2 * * ? *)"
}

variable "idp_name" {
  description = "Short name of IdP for use in logs and email alerts"
  type        = string
}

variable "memory" {
  description = "Memory (RAM) resources to allot to each task instance"
  type        = number
  default     = 32
}

variable "mysql_host" {
  description = "Address for RDS instance"
  type        = string
}

variable "mysql_pass" {
  description = "MySQL password"
  type        = string
}

variable "mysql_user" {
  description = "MySQL username"
  type        = string
}

variable "rds_arn" {
  description = <<-EOT
    The database RDS instance ARN. If not specified, the ARN will be calculated assuming the instance identifier is
    "idp-{idp_name}-{app_env}".
  EOT
  type        = string
  default     = ""
}

variable "s3_backup_bucket" {
  description = <<-EOT
    The name of the S3 bucket to use for backup storage. If not specified, a bucket will be created with the name
    {var.idp_name}-{var.app_name}-{var.app_env}.
  EOT
  type        = string
  default     = ""
}

variable "service_mode" {
  description = "Service mode, either `backup` or `restore`"
  type        = string
  default     = "backup"
}

/*
 * AWS Backup
 */

variable "enable_aws_backup" {
  description = "Enable AWS Backup in addition to the scripted backup"
  type        = bool
  default     = false
}

variable "aws_backup_schedule" {
  description = "schedule for AWS Backup, in AWS Event Bridge format"
  type        = string
  default     = "cron(0 14 * * ? *)" # Every day at 14:00 UTC, 12-hour offset from backup script
}

variable "aws_backup_notification_events" {
  description = "The names of the backup events that should trigger an email notification"
  type        = list(string)
  default     = ["BACKUP_JOB_FAILED"]
}

variable "backup_sns_email" {
  description = "Optional: email address to receive backup event notifications"
  type        = string
  default     = ""
}

variable "delete_recovery_point_after_days" {
  description = "Number of days after which AWS Backup recovery points are deleted"
  type        = number
  default     = 100
}

/*
 * Sentry logging and notification
 */

variable "sentry_dsn" {
  description = "Sentry DSN for backup failure notification"
  type        = string
  default     = ""
}

/*
 * Synchronize S3 bucket to Backblaze B2
 */

variable "enable_s3_to_b2_sync" {
  description = "Whether to enable syncing S3 to B2"
  type        = bool
  default     = false
}

variable "b2_application_key_id" {
  description = "B2 Application Key ID for authentication"
  type        = string
  default     = ""
}

variable "b2_application_key" {
  description = "B2 Application Key for authentication"
  type        = string
  sensitive   = true
  default     = ""
}

variable "b2_bucket" {
  description = "Name of the B2 bucket for syncing data"
  type        = string
  default     = ""
}

variable "b2_path" {
  description = "Path within the B2 bucket to sync data to"
  type        = string
  default     = ""
}

variable "rclone_arguments" {
  description = "Additional arguments to pass to rclone"
  type        = string
  default     = "--transfers 4 --checkers 8"
}

variable "sync_cpu" {
  description = "CPU units to allocate for the sync task"
  type        = number
  default     = 32
}

variable "sync_memory" {
  description = "Memory to allocate for the sync task"
  type        = number
  default     = 32
}

variable "sync_schedule" {
  description = "CloudWatch Events schedule expression for when to sync S3 to B2"
  type        = string
  default     = "cron(0 2 * * ? *)" // Example: Run at 2:00 AM UTC every day
}

variable "ssl_ca_base64" {
  description = "Database SSL CA PEM file, base64-encoded"
  type        = string
  default     = ""
}
