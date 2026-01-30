locals {
  aws_account = data.aws_caller_identity.this.account_id
  aws_region  = data.aws_region.current.name
  rds_arn = (
    coalesce(
      var.rds_arn,
      "arn:aws:rds:${local.aws_region}:${local.aws_account}:db:idp-${var.idp_name}-${var.app_env}"
    )
  )
  s3_backup_bucket = coalesce(var.s3_backup_bucket, "${var.idp_name}-${var.app_name}-${var.app_env}")
}


/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}

/*
 * Create S3 bucket for storing backups
 */
resource "aws_s3_bucket" "backup" {
  bucket        = local.s3_backup_bucket
  force_destroy = var.s3_bucket_force_destroy

  tags = {
    idp_name = var.idp_name
    app_name = var.app_name
    app_env  = var.app_env
  }
}

resource "aws_s3_bucket_acl" "backup" {
  bucket     = aws_s3_bucket.backup.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.backup]
}

resource "aws_s3_bucket_ownership_controls" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backup" {
  bucket = aws_s3_bucket.backup.id
  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    # empty filter applies to all objects in the bucket
    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "backup" {
  bucket = aws_s3_bucket.backup.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/*
 * Create user for putting backup files into the bucket
 */
resource "aws_iam_user" "backup" {
  name = var.backup_user_name == null ? "db-backup-${var.idp_name}-${var.app_env}" : var.backup_user_name
}

resource "aws_iam_access_key" "backup" {
  user = aws_iam_user.backup.name
}

resource "aws_iam_user_policy" "backup" {
  name = "S3-DB-Backup"
  user = aws_iam_user.backup.name

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:PutObject",
          ]
          Resource = "${aws_s3_bucket.backup.arn}*"
        },
      ]
    }
  )
}

/*
 * Create ECS service
 */
locals {
  task_def_backup = templatefile("${path.module}/task-definition.json.tftpl", {
    app_env                   = var.app_env
    app_name                  = var.app_name
    ssl_ca_base64             = var.ssl_ca_base64
    aws_region                = local.aws_region
    cloudwatch_log_group_name = var.cloudwatch_log_group_name
    aws_access_key            = aws_iam_access_key.backup.id
    aws_secret_key            = aws_iam_access_key.backup.secret
    cpu                       = var.cpu
    db_names                  = join(" ", var.db_names)
    docker_image              = var.docker_image
    mysql_host                = var.mysql_host
    mysql_pass                = var.mysql_pass
    mysql_user                = var.mysql_user
    memory                    = var.memory
    s3_bucket                 = aws_s3_bucket.backup.bucket
    sentry_dsn                = var.sentry_dsn
    service_mode              = var.service_mode
  })
}

module "backup_task" {
  source  = "sil-org/scheduled-ecs-task/aws"
  version = "~> 0.1.1"

  name                   = "${var.idp_name}-${var.app_name}-${var.app_env}"
  event_rule_description = "Start scheduled backup"
  event_schedule         = var.event_schedule
  ecs_cluster_arn        = var.ecs_cluster_id
  task_definition_arn    = aws_ecs_task_definition.cron_td.arn
  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-${var.app_env}"
  container_definitions = local.task_def_backup
  network_mode          = "bridge"
}

/*
 * AWS backup
 */
module "aws_backup" {
  count = var.enable_aws_backup ? 1 : 0

  source  = "sil-org/backup/aws"
  version = "~> 0.3.1"

  app_name               = var.idp_name
  app_env                = var.app_env
  source_arns            = [local.rds_arn]
  backup_schedule        = var.aws_backup_schedule
  notification_events    = var.aws_backup_notification_events
  sns_topic_name         = "${var.idp_name}-backup-vault-events"
  sns_email_subscription = var.backup_sns_email
  cold_storage_after     = 0
  delete_after           = var.delete_recovery_point_after_days
}


/*
 * Synchronize S3 bucket to Backblaze B2
 */
module "s3_to_b2_sync" {
  count = var.enable_s3_to_b2_sync ? 1 : 0

  source  = "sil-org/sync-s3-to-b2/aws"
  version = "~> 0.3.4"

  app_name                  = "${var.idp_name}-${var.app_name}"
  app_env                   = substr(var.app_env, 0, 4)
  s3_bucket_name            = aws_s3_bucket.backup.bucket
  s3_path                   = ""
  b2_application_key_id_arn = one(aws_ssm_parameter.b2_application_key_id[*].arn)
  b2_application_key_arn    = one(aws_ssm_parameter.b2_application_key[*].arn)
  b2_bucket                 = var.b2_bucket
  b2_path                   = var.b2_path
  rclone_arguments          = var.rclone_arguments
  log_group_name            = var.cloudwatch_log_group_name
  ecs_cluster_id            = var.ecs_cluster_id
  cpu                       = var.sync_cpu
  memory                    = var.sync_memory
  schedule                  = var.sync_schedule
}

resource "aws_ssm_parameter" "b2_application_key_id" {
  count = var.enable_s3_to_b2_sync ? 1 : 0

  name        = "/idp-${var.idp_name}/b2_application_key_id"
  type        = "SecureString"
  value       = var.b2_application_key_id
  description = "Value set by Terraform -- do not change manually."
}

resource "aws_ssm_parameter" "b2_application_key" {
  count = var.enable_s3_to_b2_sync ? 1 : 0

  name        = "/idp-${var.idp_name}/b2_application_key"
  type        = "SecureString"
  value       = var.b2_application_key
  description = "Value set by Terraform -- do not change manually."
}
