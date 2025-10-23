locals {
  aws_account          = data.aws_caller_identity.this.account_id
  aws_region           = data.aws_region.current.name
  parameter_store_path = "/idp-${var.idp_name}/"
}

/*
 * Create target group for ALB
 */
resource "aws_alb_target_group" "ssp" {
  name                 = substr("tg-${var.idp_name}-${var.app_name}-${var.app_env}", 0, 32)
  port                 = var.enable_tls ? 443 : 80
  protocol             = var.enable_tls ? "HTTPS" : "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = "30"

  health_check {
    path     = "/module.php/silauth/status.php"
    matcher  = "200"
    protocol = var.enable_tls ? "HTTPS" : "HTTP"
  }
}

/*
 * Create listener rule for hostname routing to new target group
 */
resource "aws_alb_listener_rule" "ssp" {
  listener_arn = var.alb_https_listener_arn
  priority     = "60"

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ssp.arn
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
    replace_triggered_by = [aws_alb_target_group.ssp]
  }
}

/*
 * Create ECS service
 */
resource "random_id" "admin_pass" {
  byte_length = 32
}

resource "random_id" "secretsalt" {
  byte_length = 32
}

module "cf_ips" {
  source = "github.com/silinternational/terraform-modules//cloudflare/ips?ref=8.13.2"
}

locals {
  subdomain_with_region = "${var.subdomain}-${local.aws_region}"

  trusted_ip_addresses = concat(module.cf_ips.ipv4_cidrs, var.trusted_ip_addresses)

  secret_salt = var.secret_salt == "" ? random_id.secretsalt.hex : var.secret_salt

  task_def = templatefile("${path.module}/task-definition.json.tftpl", {
    memory                      = var.memory
    cpu                         = var.cpu
    admin_email                 = var.admin_email
    admin_name                  = var.admin_name
    admin_pass                  = random_id.admin_pass.hex
    app_env                     = var.app_env
    app_name                    = var.app_name
    aws_region                  = local.aws_region
    base_url                    = "https://${var.subdomain}.${var.cloudflare_domain}/"
    cloudwatch_log_group_name   = var.cloudwatch_log_group_name
    docker_image                = var.docker_image
    enable_debug                = var.enable_debug
    password_change_url         = var.password_change_url
    password_forgot_url         = var.password_forgot_url
    hub_mode                    = var.hub_mode
    id_broker_access_token      = var.id_broker_access_token
    id_broker_assert_valid_ip   = var.id_broker_assert_valid_ip
    id_broker_base_uri          = var.id_broker_base_uri
    id_broker_trusted_ip_ranges = join(",", var.id_broker_trusted_ip_ranges)
    mfa_learn_more_url          = var.mfa_learn_more_url
    mfa_setup_url               = var.mfa_setup_url
    idp_domain_name             = "${var.subdomain}.${var.cloudflare_domain}"
    logging_level               = var.logging_level
    mysql_database              = var.db_name
    mysql_host                  = var.mysql_host
    mysql_password              = var.mysql_pass
    mysql_user                  = var.mysql_user
    parameter_store_path        = local.parameter_store_path
    port                        = var.enable_tls ? "443" : "80"
    profile_url                 = var.profile_url
    recaptcha_key               = var.recaptcha_key
    recaptcha_secret            = var.recaptcha_secret
    remember_me_secret          = var.remember_me_secret
    secret_salt                 = local.secret_salt
    show_saml_errors            = var.show_saml_errors
    ssl_ca_base64               = var.ssl_ca_base64
    theme_color_scheme          = var.theme_color_scheme
    trusted_ip_addresses        = join(",", local.trusted_ip_addresses)
    analytics_id                = var.analytics_id
    help_center_url             = var.help_center_url
  })
}

module "ecsservice" {
  source             = "github.com/silinternational/terraform-modules//aws/ecs/service-only?ref=8.13.2"
  cluster_id         = var.ecs_cluster_id
  service_name       = "${var.idp_name}-${var.app_name}"
  service_env        = var.app_env
  container_def_json = local.task_def
  desired_count      = var.desired_count
  tg_arn             = aws_alb_target_group.ssp.arn
  lb_container_name  = "web"
  lb_container_port  = var.enable_tls ? "443" : "80"
  ecsServiceRole_arn = var.ecsServiceRole_arn
  task_role_arn      = module.ecs_role.role_arn
}

/*
 * Create Cloudflare DNS record(s)
 */
resource "cloudflare_record" "sspdns" {
  count = var.create_dns_record ? 1 : 0

  zone_id = data.cloudflare_zone.domain.id
  name    = var.subdomain
  value   = cloudflare_record.sspdns_intermediate.hostname
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "sspdns_intermediate" {
  zone_id = data.cloudflare_zone.domain.id
  name    = local.subdomain_with_region
  value   = var.alb_dns_name
  type    = "CNAME"
  proxied = true
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
