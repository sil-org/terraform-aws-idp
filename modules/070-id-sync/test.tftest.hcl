mock_provider "aws" {
  mock_resource "aws_iam_role" {
    defaults = {
      arn = "arn:aws:iam::111111111111:role/test-role"
    }
  }
  mock_resource "aws_ecs_task_definition" {
    defaults = {
      arn = "arn:aws:ecs:us-east-1:111111111111:task-definition/test-task-definition:1"
    }
  }
}

variables {
  app_env                   = ""
  cloudwatch_log_group_name = ""
  docker_image              = ""
  id_broker_base_url        = ""
  id_broker_trustedIpRanges = []
  id_store_adapter          = ""
  id_store_config           = {}
  idp_name                  = ""
  ecs_cluster_id            = ""
  task_execution_role_arn   = ""
}

run "test" {}
