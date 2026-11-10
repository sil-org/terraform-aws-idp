
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
}

mock_provider "cloudflare" {}

variables {
  # required variables
  alb_dns_name              = ""
  alb_https_listener_arn    = ""
  api_subdomain             = "api"
  app_env                   = "test"
  auth_saml_idpCertificate  = ""
  auth_saml_spCertificate   = ""
  cloudflare_domain         = "example.com"
  cloudwatch_log_group_name = ""
  cd_role_name              = ""
  docker_image              = ""
  ecsServiceRole_arn        = ""
  ecs_cluster_id            = ""
  email_signature           = ""
  help_center_url           = ""
  id_broker_base_uri        = ""
  id_broker_validIpRanges   = [""]
  idp_display_name          = ""
  idp_name                  = ""
  support_email             = ""
  support_name              = ""
  support_phone             = ""
  support_url               = ""
  task_execution_role_arn   = ""
  ui_subdomain              = "profile"
  vpc_id                    = ""
}

run "test" {
  assert {
    condition     = cloudflare_dns_record.apidns_intermediate.name == "api-us-east-1.example.com"
    error_message = "A single-label subdomain must have the region appended before the domain."
  }

  assert {
    condition     = output.api_public_dns_value == cloudflare_dns_record.apidns_intermediate.name
    error_message = "The public DNS value must match the regional DNS record."
  }

  assert {
    condition     = cloudflare_dns_record.apidns[0].name == "api.example.com" && cloudflare_dns_record.apidns[0].content == output.api_public_dns_value
    error_message = "The public DNS record must point the unmodified subdomain at the regional hostname."
  }

  assert {
    condition     = toset(one(one(aws_alb_listener_rule.pwmanager.condition).host_header).values) == toset(["api.example.com", "api-us-east-1.example.com"])
    error_message = "The listener must accept the public and regional hostnames without duplicating the domain."
  }

  assert {
    condition     = output.ui_hostname == "${var.ui_subdomain}.${var.cloudflare_domain}"
    error_message = "ui_hostname must be of the form <ui_subdomain>.<cloudflare_domain>"
  }

  assert {
    condition     = output.ui_base_url == "https://profile.example.com"
    error_message = "ui_base_url must be https://<ui_hostname> when ui_path is empty"
  }
}

run "two_label_subdomain" {
  variables {
    api_subdomain = "api.login"
  }

  assert {
    condition     = cloudflare_dns_record.apidns_intermediate.name == "api-us-east-1.login.example.com"
    error_message = "The region must be appended to the first label, preserving the second label."
  }
}

run "multi_label_subdomain" {
  variables {
    api_subdomain = "api.login.internal"
  }

  assert {
    condition     = cloudflare_dns_record.apidns_intermediate.name == "api-us-east-1.login.internal.example.com"
    error_message = "The region must be appended only to the first label, preserving all remaining labels."
  }
}

run "ui_path" {
  variables {
    ui_path = "/profile"
  }

  assert {
    condition     = output.ui_base_url == "https://profile.example.com/profile"
    error_message = "ui_base_url must be https://<ui_hostname><ui_path>"
  }
}

run "ui_path_trailing_slash" {
  command = plan

  variables {
    ui_path = "/profile/"
  }

  expect_failures = [var.ui_path]
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
