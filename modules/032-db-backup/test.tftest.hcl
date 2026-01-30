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
  app_env                   = "test"
  cloudwatch_log_group_name = ""
  docker_image              = ""
  ecs_cluster_id            = ""
  idp_name                  = ""
  mysql_host                = ""
  mysql_pass                = ""
  mysql_user                = ""
}

run "test" {}
