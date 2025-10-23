locals {
  aws_account          = data.aws_caller_identity.this.account_id
  aws_region           = data.aws_region.current.name
  parameter_store_path = "/idp-${var.idp_name}/"

  /*
   * Create ECS service
   */
  id_store_config = join(",",
    [for k, v in var.id_store_config : jsonencode({
      name  = "ID_STORE_CONFIG_${k}"
      value = v
    })]
  )

  task_def = templatefile("${path.module}/task-definition.json.tftpl", {
    app_env                      = var.app_env
    app_name                     = var.app_name
    aws_region                   = local.aws_region
    cloudwatch_log_group_name    = var.cloudwatch_log_group_name
    docker_image                 = var.docker_image
    id_broker_access_token       = var.id_broker_access_token
    id_broker_adapter            = var.id_broker_adapter
    id_broker_assertValidIp      = var.id_broker_assertValidIp
    id_broker_base_url           = var.id_broker_base_url
    id_broker_trustedIpRanges    = join(",", var.id_broker_trustedIpRanges)
    id_store_adapter             = var.id_store_adapter
    id_store_config              = local.id_store_config == "" ? "" : ",${local.id_store_config}"
    idp_name                     = var.idp_name
    idp_display_name             = var.idp_display_name
    alerts_email                 = var.alerts_email
    notifier_email_to            = var.notifier_email_to
    memory                       = var.memory
    cpu                          = var.cpu
    parameter_store_path         = local.parameter_store_path
    sync_safety_cutoff           = var.sync_safety_cutoff
    allow_empty_email            = var.allow_empty_email
    enable_new_user_notification = var.enable_new_user_notification
    sentry_dsn                   = var.sentry_dsn
    heartbeat_url                = var.heartbeat_url
    heartbeat_method             = var.heartbeat_method
  })
}

module "cron_task" {
  source  = "silinternational/scheduled-ecs-task/aws"
  version = "~> 0.1"

  name                   = "${var.idp_name}-${var.app_name}-cron-${var.app_env}-${local.aws_region}"
  event_rule_description = "Start ID Sync scheduled tasks"
  enable                 = var.enable_sync
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
  family                = "${var.idp_name}-${var.app_name}-cron-${var.app_env}"
  container_definitions = local.task_def
  network_mode          = "bridge"
  task_role_arn         = module.ecs_role.role_arn
}

/*
 * Create ECS role
 */
module "ecs_role" {
  source = "../ecs-role"

  name = "ecs-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"
}

moved {
  from = module.ecs_role[0]
  to   = module.ecs_role
}

resource "aws_iam_role_policy" "parameter_store" {
  name = "parameter-store"
  role = module.ecs_role.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "ParameterStore"
      Effect = "Allow"
      Action = [
        "ssm:GetParametersByPath",
      ]
      Resource = "arn:aws:ssm:*:${local.aws_account}:parameter${local.parameter_store_path}*"
    }]
  })
}

/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}
