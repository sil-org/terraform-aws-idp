
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
  alb_dns_name              = ""
  alb_https_listener_arn    = ""
  api_subdomain             = ""
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
    condition     = output.ui_hostname == "${var.ui_subdomain}.${var.cloudflare_domain}"
    error_message = "ui_hostname must be of the form <ui_subdomain>.<cloudflare_domain>"
  }

  assert {
    condition     = output.ui_base_url == "https://profile.example.com"
    error_message = "ui_base_url must be https://<ui_hostname> when ui_path is empty"
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
