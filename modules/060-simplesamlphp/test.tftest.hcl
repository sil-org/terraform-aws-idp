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
  cd_role_name              = ""
  cloudflare_domain         = ""
  cloudwatch_log_group_name = ""
  db_name                   = ""
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  help_center_url           = ""
  id_broker_base_uri        = ""
  idp_name                  = ""
  mfa_learn_more_url        = ""
  mfa_setup_url             = ""
  mysql_host                = ""
  mysql_user                = ""
  password_change_url       = ""
  password_forgot_url       = ""
  profile_url               = ""
  subdomain                 = ""
  task_execution_role_arn   = ""
  trusted_ip_addresses      = []
  vpc_id                    = ""
}

run "test_ip_addresses" {
  assert {
    condition     = length(local.trusted_ip_addresses) > 0
    error_message = "trusted_ip_addresses is not correct"
  }
}

run "trusted_ip_addresses_include_cloudflare_ipv6" {
  assert {
    condition     = alltrue([for cidr in split(",", data.external.cloudflare_ips.result.ipv6_cidrs) : contains(local.trusted_ip_addresses, cidr)])
    error_message = "trusted_ip_addresses must include all Cloudflare IPv6 ranges"
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

run "dynamodb_policy_not_created_by_default" {
  assert {
    condition     = length(aws_iam_role_policy.dynamodb) == 0
    error_message = "dynamodb policy should not be created when dynamodb_table_arn is not set"
  }
}

run "dynamodb_policy" {
  variables {
    dynamodb_table_arn = "arn:aws:dynamodb:us-east-1:111111111111:table/test-table"
  }

  assert {
    condition     = strcontains(aws_iam_role_policy.dynamodb[0].policy, var.dynamodb_table_arn)
    error_message = "dynamodb policy does not reference the correct table ARN"
  }
}
