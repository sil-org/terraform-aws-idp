locals {
  aws_account          = data.aws_caller_identity.this.account_id
  aws_region           = data.aws_region.current.name
  parameter_store_path = "/idp-${var.idp_name}/"
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

resource "random_id" "this" { byte_length = 2 }

/*
 * Create S3 bucket for storing backups
 */
resource "aws_s3_bucket" "backup" {
  bucket        = local.s3_backup_bucket
  force_destroy = true

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
 * Create ECS task
 */
locals {
  task_def_backup = jsonencode([{
    cpu               = var.cpu
    memoryReservation = var.memory
    memory            = var.memory
    essential         = true
    name              = "cron"
    environment = [
      {
        name  = "DB_NAMES",
        value = join(" ", var.db_names)
      },
      {
        name  = "MODE",
        value = var.service_mode
      },
      {
        name  = "SSL_CA_BASE64",
        value = var.ssl_ca_base64
      },
      {
        name  = "MYSQL_HOST",
        value = var.mysql_host
      },
      {
        name  = "MYSQL_USER",
        value = var.mysql_user
      },
      {
        name  = "S3_BUCKET",
        value = "s3://${aws_s3_bucket.backup.bucket}"
      },
      {
        name  = "SENTRY_DSN",
        value = var.sentry_dsn
      },
    ]
    secrets = [
      {
        name      = "AWS_ACCESS_KEY"
        valueFrom = aws_ssm_parameter.access_key_id.arn
      },
      {
        name      = "AWS_SECRET_KEY"
        valueFrom = aws_ssm_parameter.secret_access_key.arn
      },
      {
        name      = "MYSQL_PASSWORD"
        valueFrom = aws_ssm_parameter.mysql_password.arn
      },
    ]
    image = var.docker_image
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = var.cloudwatch_log_group_name
        awslogs-region        = local.aws_region
        awslogs-stream-prefix = "${var.app_name}-${var.app_env}"
      }
    }
  }])
}

resource "aws_ssm_parameter" "access_key_id" {
  name        = "${local.parameter_store_path}/access_key_id"
  type        = "SecureString"
  value       = aws_iam_access_key.backup.id
  description = "Value set by Terraform -- do not change manually."
}

resource "aws_ssm_parameter" "secret_access_key" {
  name        = "${local.parameter_store_path}/secret_access_key"
  type        = "SecureString"
  value       = aws_iam_access_key.backup.secret
  description = "Value set by Terraform -- do not change manually."
}

resource "aws_ssm_parameter" "mysql_password" {
  name        = "${local.parameter_store_path}/mysql_password"
  type        = "SecureString"
  value       = var.mysql_pass
  description = "Value set by Terraform -- do not change manually."
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
 * ECS Task Execution Role to allow ECS to assume a role for access to SSM Parameter Store
 */

resource "aws_iam_role" "task_exec" {
  name = "task-exec-${var.idp_name}-${random_id.this.hex}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Action    = "sts:AssumeRole"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec" {
  role       = aws_iam_role.task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "task_exec" {
  name = "ssm-parameter-access"
  role = aws_iam_role.task_exec.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ssm:GetParameters",
        "ssm:PutParameters",
        "ssm:DeleteParameters",
      ]
      Resource = "arn:aws:ssm:${local.aws_region}:${local.aws_account}:parameter${local.parameter_store_path}/*"
    }]
  })
}

resource "aws_iam_policy" "pass_role" {
  name = "task-exec-pass-role-${var.app_name}-${var.app_env}-${local.aws_region}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = {
      Effect = "Allow"
      Action = [
        "iam:PassRole",
      ]
      Resource = aws_iam_role.task_exec.arn
    }
  })
}

resource "aws_iam_user_policy_attachment" "pass_role" {
  user       = var.cd_user
  policy_arn = aws_iam_policy.pass_role
}

/*
 * Create cron task definition
 */
resource "aws_ecs_task_definition" "cron_td" {
  family                = "${var.idp_name}-${var.app_name}-${var.app_env}"
  container_definitions = local.task_def_backup
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.task_exec.arn
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
  version = "~> 0.2.0"

  app_name              = "${var.idp_name}-${var.app_name}"
  app_env               = substr(var.app_env, 0, 4)
  s3_bucket_name        = aws_s3_bucket.backup.bucket
  s3_path               = ""
  b2_application_key_id = var.b2_application_key_id
  b2_application_key    = var.b2_application_key
  b2_bucket             = var.b2_bucket
  b2_path               = var.b2_path
  rclone_arguments      = var.rclone_arguments
  log_group_name        = var.cloudwatch_log_group_name
  ecs_cluster_id        = var.ecs_cluster_id
  cpu                   = var.sync_cpu
  memory                = var.sync_memory
  schedule              = var.sync_schedule
}
