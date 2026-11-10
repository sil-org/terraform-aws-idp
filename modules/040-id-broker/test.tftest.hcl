
mock_provider "aws" {
  mock_data "aws_region" {
    defaults = {
      region = "us-east-1"
    }
  }
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
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{}"
    }
  }
}

mock_provider "cloudflare" {}

variables {
  # required variables
  app_env                   = "test"
  cd_role_name              = ""
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
    condition     = cloudflare_dns_record.brokerdns.name == "broker-us-east-1.example.com"
    error_message = "A single-label subdomain must have the region appended before the domain."
  }

  assert {
    condition     = cloudflare_dns_record.brokerdns.name == output.hostname && output.public_dns_value == output.hostname
    error_message = "The regional DNS record and public DNS value must match the hostname."
  }

  assert {
    condition     = cloudflare_dns_record.public[0].name == "broker.example.com" && cloudflare_dns_record.public[0].content == output.hostname
    error_message = "The public DNS record must point the unmodified subdomain at the regional hostname."
  }

  assert {
    condition     = toset(one(one(aws_alb_listener_rule.broker.condition).host_header).values) == toset(["broker.example.com", "broker-us-east-1.example.com"])
    error_message = "The listener must accept the public and regional hostnames without duplicating the domain."
  }
}

run "two_label_subdomain" {
  variables {
    subdomain = "broker.login"
  }

  assert {
    condition     = cloudflare_dns_record.brokerdns.name == "broker-us-east-1.login.example.com"
    error_message = "The region must be appended to the first label, preserving the second label."
  }
}

run "multi_label_subdomain" {
  variables {
    subdomain = "broker.login.internal"
  }

  assert {
    condition     = cloudflare_dns_record.brokerdns.name == "broker-us-east-1.login.internal.example.com"
    error_message = "The region must be appended only to the first label, preserving all remaining labels."
  }
}

run "cd_role_attachment" {
  variables {
    cd_role_name = "cd-test"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.cd.role == var.cd_role_name
    error_message = "cd role policy attachment is not attached to the correct role"
  }
}

run "create_access_key" {
  variables {
    create_access_key = true
  }

  assert {
    condition     = length(aws_ssm_parameter.id_broker_access_token) > 0
    error_message = "id_broker_access_token parameter should exist"
  }

  assert {
    condition     = length(aws_ssm_parameter.api_access_keys) > 0
    error_message = "api_access_keys parameter should exist"
  }
}
