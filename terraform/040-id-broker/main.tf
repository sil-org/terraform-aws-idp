locals {
  aws_account          = data.aws_caller_identity.this.account_id
  aws_region           = data.aws_region.current.name
  parameter_store_path = "/idp-${var.idp_name}/"
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "broker" {
  name                 = substr("tg-${var.idp_name}-${var.app_name}-${var.app_env}", 0, 32)
  port                 = var.disable_tls ? 80 : 443
  protocol             = var.disable_tls ? "HTTP" : "HTTPS"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"

  stickiness {
    type = "lb_cookie"
  }

  health_check {
    path     = "/site/status"
    matcher  = "200,204"
    protocol = var.disable_tls ? "HTTP" : "HTTPS"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "broker" {
  listener_arn = coalesce(var.internal_alb_listener_arn, var.alb_listener_arn)
  priority     = "40"

  action {
    target_group_arn = aws_alb_target_group.broker.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = [
        "${var.subdomain}.${var.cloudflare_domain}",
        "${local.subdomain_with_region}.${var.cloudflare_domain}"
      ]
    }
  }

  lifecycle {
    replace_triggered_by = [aws_alb_target_group.broker]
  }
}

/*
 * Generate access tokens for consuming apps
 */
resource "random_id" "access_token_pwmanager" {
  byte_length = 16
}

resource "random_id" "access_token_search" {
  byte_length = 16
}

resource "random_id" "access_token_ssp" {
  byte_length = 16
}

resource "random_id" "access_token_idsync" {
  byte_length = 16
}

resource "random_id" "access_token_pwmanager_b" {
  byte_length = 32
}

resource "random_id" "access_token_search_b" {
  byte_length = 32
}

resource "random_id" "access_token_ssp_b" {
  byte_length = 32
}

resource "random_id" "access_token_idsync_b" {
  byte_length = 32
}

/*
 * Create ECS service
 */
locals {
  google_vars = join(",",
    [for k, v in var.google_config : jsonencode({
      name  = "GOOGLE_${k}"
      value = v
    })]
  )
  api_access_keys = join(",", [
    random_id.access_token_pwmanager.hex,
    random_id.access_token_search.hex,
    random_id.access_token_ssp.hex,
    random_id.access_token_idsync.hex,
    random_id.access_token_pwmanager_b.hex,
    random_id.access_token_search_b.hex,
    random_id.access_token_ssp_b.hex,
    random_id.access_token_idsync_b.hex,
  ])

  subdomain_with_region = "${var.subdomain}-${local.aws_region}"

  task_def = templatefile("${path.module}/task-definition.json.tftpl", local.task_def_vars)
  task_def_vars = {
    api_access_keys                            = local.api_access_keys
    abandoned_user_abandoned_period            = var.abandoned_user_abandoned_period
    abandoned_user_best_practice_url           = var.abandoned_user_best_practice_url
    abandoned_user_deactivate_instructions_url = var.abandoned_user_deactivate_instructions_url
    app_env                                    = var.app_env
    app_name                                   = var.app_name
    aws_region                                 = local.aws_region
    cloudwatch_log_group_name                  = var.cloudwatch_log_group_name
    command                                    = "/data/run.sh"
    contingent_user_duration                   = var.contingent_user_duration
    cpu                                        = var.cpu
    db_name                                    = var.db_name
    docker_image                               = var.docker_image
    email_brand_color                          = var.email_brand_color
    email_brand_logo                           = var.email_brand_logo
    email_repeat_delay_days                    = var.email_repeat_delay_days
    email_signature                            = var.email_signature
    from_email                                 = var.from_email
    from_name                                  = var.from_name
    google_config                              = local.google_vars
    help_center_url                            = var.help_center_url
    hibp_check_interval                        = var.hibp_check_interval
    hibp_check_on_login                        = var.hibp_check_on_login
    hibp_grace_period                          = var.hibp_grace_period
    hibp_tracking_only                         = var.hibp_tracking_only
    hibp_notification_bcc                      = var.hibp_notification_bcc
    hr_notifications_email                     = var.hr_notifications_email
    idp_display_name                           = var.idp_display_name
    idp_name                                   = var.idp_name
    inactive_user_period                       = var.inactive_user_period
    inactive_user_deletion_enable              = var.inactive_user_deletion_enable
    invite_email_delay_seconds                 = var.invite_email_delay_seconds
    invite_grace_period                        = var.invite_grace_period
    invite_lifespan                            = var.invite_lifespan
    lost_security_key_email_days               = var.lost_security_key_email_days
    memory                                     = var.memory
    method_add_interval                        = var.method_add_interval
    method_codeLength                          = var.method_codeLength
    method_gracePeriod                         = var.method_gracePeriod
    method_lifetime                            = var.method_lifetime
    method_maxAttempts                         = var.method_maxAttempts
    mfa_add_interval                           = var.mfa_add_interval
    mfa_allow_disable                          = var.mfa_allow_disable
    mfa_lifetime                               = var.mfa_lifetime
    mfa_manager_bcc                            = var.mfa_manager_bcc
    mfa_manager_help_bcc                       = var.mfa_manager_help_bcc
    mfa_required_for_new_users                 = var.mfa_required_for_new_users
    mfa_totp_apibaseurl                        = var.mfa_api_base_url
    mfa_webauthn_apibaseurl                    = var.mfa_api_base_url
    rp_origins                                 = var.rp_origins
    minimum_backup_codes_before_nag            = var.minimum_backup_codes_before_nag
    mfa_webauthn_rpid                          = var.cloudflare_domain
    mysql_host                                 = var.mysql_host
    mysql_pass                                 = var.mysql_pass
    mysql_user                                 = var.mysql_user
    name                                       = "web"
    notification_email                         = var.notification_email
    parameter_store_path                       = local.parameter_store_path
    password_expiration_grace_period           = var.password_expiration_grace_period
    password_lifespan                          = var.password_lifespan
    password_mfa_lifespan_extension            = var.password_mfa_lifespan_extension
    password_profile_url                       = var.password_profile_url
    password_reuse_limit                       = var.password_reuse_limit
    port                                       = var.disable_tls ? "80" : "443"
    profile_review_interval                    = var.profile_review_interval
    run_task                                   = ""
    send_get_backup_codes_emails               = var.send_get_backup_codes_emails
    send_invite_emails                         = var.send_invite_emails
    send_lost_security_key_emails              = var.send_lost_security_key_emails
    send_method_purged_emails                  = var.send_method_purged_emails
    send_method_reminder_emails                = var.send_method_reminder_emails
    send_mfa_disabled_emails                   = var.send_mfa_disabled_emails
    send_mfa_enabled_emails                    = var.send_mfa_enabled_emails
    send_mfa_option_added_emails               = var.send_mfa_option_added_emails
    send_mfa_option_removed_emails             = var.send_mfa_option_removed_emails
    send_mfa_rate_limit_emails                 = var.send_mfa_rate_limit_emails
    send_password_changed_emails               = var.send_password_changed_emails
    send_password_expired_emails               = var.send_password_expired_emails
    send_password_expiring_emails              = var.send_password_expiring_emails
    send_refresh_backup_codes_emails           = var.send_refresh_backup_codes_emails
    send_welcome_emails                        = var.send_welcome_emails
    sentry_dsn                                 = var.sentry_dsn
    ssl_ca_base64                              = var.ssl_ca_base64
    subject_for_abandoned_users                = var.subject_for_abandoned_users
    subject_for_get_backup_codes               = var.subject_for_get_backup_codes
    subject_for_invite                         = var.subject_for_invite
    subject_for_lost_security_key              = var.subject_for_lost_security_key
    subject_for_method_purged                  = var.subject_for_method_purged
    subject_for_method_reminder                = var.subject_for_method_reminder
    subject_for_method_verify                  = var.subject_for_method_verify
    subject_for_mfa_disabled                   = var.subject_for_mfa_disabled
    subject_for_mfa_enabled                    = var.subject_for_mfa_enabled
    subject_for_mfa_manager                    = var.subject_for_mfa_manager
    subject_for_mfa_manager_help               = var.subject_for_mfa_manager_help
    subject_for_mfa_option_added               = var.subject_for_mfa_option_added
    subject_for_mfa_option_removed             = var.subject_for_mfa_option_removed
    subject_for_mfa_rate_limit                 = var.subject_for_mfa_rate_limit
    subject_for_password_changed               = var.subject_for_password_changed
    subject_for_password_expired               = var.subject_for_password_expired
    subject_for_password_expiring              = var.subject_for_password_expiring
    subject_for_refresh_backup_codes           = var.subject_for_refresh_backup_codes
    subject_for_welcome                        = var.subject_for_welcome
    support_email                              = var.support_email
    support_name                               = var.support_name
  }
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=8.13.2"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = var.app_env
  ecsServiceRole_arn = var.ecsServiceRole_arn
  container_def_json = local.task_def
  desired_count      = var.desired_count
  tg_arn             = aws_alb_target_group.broker.arn
  lb_container_name  = "web"
  lb_container_port  = var.disable_tls ? "80" : "443"
  task_role_arn      = module.ecs_role.role_arn
}

module "cron_task" {
  source  = "silinternational/scheduled-ecs-task/aws"
  version = "~> 0.1"

  name                   = "${var.idp_name}-${var.app_name}-cron-${var.app_env}-${local.aws_region}"
  event_rule_description = "Start broker scheduled tasks"
  event_schedule         = var.event_schedule
  ecs_cluster_arn        = var.ecs_cluster_id
  task_definition_arn    = module.ecsservice.task_def_arn
  event_target_input = jsonencode({
    containerOverrides = [
      {
        name   = "web"
        cpu    = var.cpu_cron
        memory = var.memory_cron
        environment = [
          {
            "name" : "RUN_TASK",
            "value" : var.run_task
          }
        ]
      }
    ]
  })
  tags = {
    app_name = var.app_name
    app_env  = var.app_env
  }
}

/*
 * Create an ECS service for sending queued email. This simply runs a container that checks the email queue once per
 * minute, sending any email messages in the queue that are due to send.
 */

locals {
  email_task_def = templatefile("${path.module}/task-definition.json.tftpl", merge(
    local.task_def_vars,
    {
      name    = "email"
      command = "/data/run-cron.sh"
      memory  = var.memory_email
      cpu     = var.cpu_email
    }
  ))
}

module "email_service" {
  source  = "silinternational/ecs-service/aws"
  version = "~> 0.3.0"

  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}-email"
  service_env        = var.app_env
  container_def_json = local.email_task_def
  desired_count      = 1
  task_role_arn      = module.ecs_role.role_arn
}


/*
 * Create Cloudflare DNS record(s)
 */
resource "cloudflare_record" "public" {
  count = var.create_dns_record ? 1 : 0

  zone_id = data.cloudflare_zone.domain.id
  name    = var.subdomain
  value   = cloudflare_record.brokerdns.hostname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "brokerdns" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.subdomain_with_region
  value   = coalesce(var.internal_alb_dns_name, var.alb_dns_name)
  type    = "CNAME"

  # If the internal ALB DNS name is not specified, this should be proxied to bridge between IPv4 and IPv6. Outbound
  # connections only support IPv4, for reasons not well understood by me. Inbound connections only support IPv6 by
  # design, to decrease AWS costs.
  proxied = var.internal_alb_dns_name == ""
}

data "cloudflare_zone" "domain" {
  name = var.cloudflare_domain
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

resource "aws_iam_role_policy" "ses" {
  name = "ses"
  role = module.ecs_role.role_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid      = "SendEmail"
      Effect   = "Allow"
      Action   = "ses:SendEmail"
      Resource = "*"
      Condition = {
        StringEquals = {
          "ses:FromAddress" = var.from_email
        }
      }
    }]
  })
}

resource "aws_iam_user_policy_attachment" "cd" {
  user       = var.cduser_username
  policy_arn = aws_iam_policy.cd.arn
}

resource "aws_iam_policy" "cd" {
  name = "cd-policy-${var.idp_name}-${var.app_name}-${var.app_env}-${local.aws_region}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ECS"
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "ecs:RegisterTaskDefinition",
        ]
        Resource = [
          module.ecsservice.service_id,
          "arn:aws:ecs:${local.aws_region}:${local.aws_account}:task-definition/${module.ecsservice.task_def_family}:*",
        ]
      },
      {
        Sid      = "PassRole"
        Effect   = "Allow"
        Action   = "iam:PassRole"
        Resource = module.ecs_role.role_arn
      },
    ]
  })
}

/*
 * AWS data
 */

data "aws_caller_identity" "this" {}

data "aws_region" "current" {}
