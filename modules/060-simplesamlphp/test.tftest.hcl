mock_provider "aws" {
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::111111111111:role/test-role"
    }
  }
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::111111111111:policy/test-policy"
    }
  }
  mock_resource "aws_alb_target_group" {
    defaults = {
      arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/test-tg"
    }
  }
}

mock_provider "cloudflare" {}

variables {
  admin_email               = ""
  admin_name                = ""
  alb_dns_name              = ""
  alb_https_listener_arn    = ""
  analytics_id              = ""
  app_env                   = "test"
  cduser_username           = ""
  cloudflare_domain         = ""
  cloudwatch_log_group_name = ""
  db_name                   = ""
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  help_center_url           = ""
  id_broker_access_token    = ""
  id_broker_base_uri        = ""
  idp_name                  = ""
  mfa_learn_more_url        = ""
  mfa_setup_url             = ""
  mysql_host                = ""
  mysql_pass                = ""
  mysql_user                = ""
  password_change_url       = ""
  password_forgot_url       = ""
  profile_url               = ""
  recaptcha_key             = ""
  recaptcha_secret          = ""
  remember_me_secret        = ""
  subdomain                 = ""
  trusted_ip_addresses      = []
  vpc_id                    = ""
}

run "test" {
  assert {
    condition     = length(local.trusted_ip_addresses) > 0
    error_message = "trusted_ip_addresses is not correct"
  }
}
