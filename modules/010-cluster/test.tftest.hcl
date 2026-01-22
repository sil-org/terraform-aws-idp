mock_provider "aws" {
  mock_resource "aws_alb" {
    defaults = {
      arn = "arn:aws:elasticloadbalancing::111111111111:loadbalancer/test-load-balancer"
    }
  }
  mock_resource "aws_launch_template" {
    defaults = {
      arn = "arn:aws:ec2::111111111111:launch-template/test-launch-template"
      id  = "lt-abcd1234"
    }
  }
  mock_resource "aws_alb_target_group" {
    defaults = {
      arn = "arn:aws:elasticloadbalancing:us-east-1:111111111111:targetgroup/test-target-group"
    }
  }

  mock_data "aws_acm_certificate" {
    defaults = {
      arn = "arn:aws:acm:us-east-1:111111111111:certificate/test-certificate"
    }
  }
}

variables {
  app_name = ""
  app_env  = "test"
  aws_instance = {
    instance_count = 0
    instance_type  = ""
    volume_size    = 0
  }
  aws_zones               = ["us-east-1a"]
  cert_domain_name        = ""
  ecs_cluster_name        = ""
  ecs_instance_profile_id = ""
  idp_name                = ""
}

run "test" {
  assert {
    condition     = length(data.external.cloudflare_ips.result.ipv6_cidrs) > 10
    error_message = "ipv6_cidrs is not correct"
  }
  assert {
    condition     = length(aws_security_group_rule.cloudflare.cidr_blocks) > 0
    error_message = "Cloudflare security group rule cidr_blocks is not correct"
  }
  assert {
    condition     = length(aws_security_group_rule.cloudflare.ipv6_cidr_blocks) > 0
    error_message = "Cloudflare security group rule ipv6_cidr_blocks is not correct"
  }
}
