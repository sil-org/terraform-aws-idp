module "backup" {
  source = "../modules/032-db-backup"

  app_env                          = ""
  app_name                         = ""
  backup_role_name                 = ""
  cloudwatch_log_group_name        = ""
  cpu                              = 1
  event_schedule                   = ""
  db_names                         = [""]
  docker_image                     = ""
  ecs_cluster_id                   = ""
  idp_name                         = ""
  memory                           = 1
  mysql_host                       = ""
  mysql_user                       = ""
  service_mode                     = ""
  enable_aws_backup                = true
  aws_backup_schedule              = ""
  aws_backup_notification_events   = [""]
  backup_sns_email                 = ""
  delete_recovery_point_after_days = 7
  b2_application_key_id            = ""
  b2_application_key               = ""
  b2_bucket                        = ""
  task_execution_role_arn          = ""
}
