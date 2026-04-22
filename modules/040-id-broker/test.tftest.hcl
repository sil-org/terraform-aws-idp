
mock_provider "aws" {
  mock_resource "aws_ecs_task_definition" {
    defaults = {
      arn = "arn:aws:ecs:us-east-1:111111111111:task-definition/test-task-definition:1"
    }
  }
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
  # required variables
  app_env                   = "test"
  cloudflare_domain         = "example.com"
  cloudwatch_log_group_name = ""
  db_name                   = ""
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  help_center_url           = ""
  idp_name                  = ""
  mysql_host                = ""
  mysql_user                = ""
  notification_email        = ""
  password_profile_url      = ""
  rp_origins                = ""
  subdomain                 = "broker"
  support_email             = ""
  task_execution_role_arn   = ""
  vpc_id                    = ""

  # either an internal or an external alb dns name and listener arn must be specified
  internal_alb_dns_name     = "internal-alb-idp-example-test-int-3333333333.us-east-1.elb.amazonaws.com"
  internal_alb_listener_arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:listener/app/alb-idp-example-test-int/00000000aaaaaaaa/11111111bbbbbbbb"
}

run "test" {
  assert {
    condition     = can(regex("^${var.subdomain}-[0-9a-z]+\\.${var.cloudflare_domain}$", output.hostname))
    error_message = "hostname must be of the form <subdomain>-<region>.<cloudflare_domain>"
  }
}

run "test_no_cd_role" {
  assert {
    condition     = length(aws_iam_role_policy_attachment.cd) == 0
    error_message = "cd role policy attachment is not attached to the correct role"
  }
}

run "cd_role_attachment" {
  variables {
    cd_role_name = "cd-test"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.cd[0].role == var.cd_role_name
    error_message = "cd role policy attachment is not attached to the correct role"
  }
}
