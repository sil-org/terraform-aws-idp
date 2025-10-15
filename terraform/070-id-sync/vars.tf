variable "memory" {
  description = <<-EOT
    Amount of memory, specified in MB, to allocate to container. This value is used for the "memory" and
    "memoryReservation" container definition parameters.
  EOT
  type        = number
  default     = 200
}

variable "cpu" {
  description = "CPU allocation for the container. Specified in AWS CPU units: 1000 is one CPU"
  type        = number
  default     = 200
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "id-sync"
}

variable "app_env" {
  description = "Application environment"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "docker_image" {
  description = "URL to Docker image"
  type        = string
}

variable "id_broker_access_token" {
  description = "Access token for calling id-broker"
  type        = string
}

variable "id_broker_adapter" {
  description = "Which ID Sync adapter to use"
  type        = string
  default     = "idp"
}

variable "id_broker_assertValidIp" {
  description = "Whether or not to assert IP address for ID Broker API is trusted"
  type        = bool
  default     = true
}

variable "id_broker_base_url" {
  description = "Base URL to id-broker API"
  type        = string
}

variable "id_broker_trustedIpRanges" {
  description = "List of valid IP address ranges for ID Broker API"
  type        = list(string)
}

variable "id_store_adapter" {
  description = "Which ID Store adapter to use"
  type        = string
}

variable "id_store_config" {
  description = "A map of configuration data to pass into id-sync as env vars prefixed with `ID_STORE_CONFIG_`"
  type        = map(string)
}

variable "idp_name" {
  description = "Short name of IdP for use in logs and email alerts"
  type        = string
}

variable "idp_display_name" {
  description = "Friendly name for IdP"
  type        = string
  default     = ""
}

variable "ecs_cluster_id" {
  description = "ID for ECS Cluster"
  type        = string
}

variable "notifier_email_to" {
  description = "Email address for Human Resources (HR) notification messages"
  type        = string
  default     = ""
}

variable "alerts_email" {
  description = "Email address for exception messages"
  type        = string
  default     = ""
}

variable "sync_safety_cutoff" {
  description = "The percentage of records allowed to be changed during a sync, provided as a float, ex: `0.2` for `20%`"
  type        = number
  default     = 0.15
}

variable "allow_empty_email" {
  description = "Whether to allow the primary email property to be empty."
  type        = bool
  default     = false
}

variable "enable_new_user_notification" {
  description = "Enable email notification to HR Contact upon creation of a new user, if set to 'true'."
  type        = bool
  default     = false
}

variable "enable_sync" {
  description = "Sets the AWS CloudWatch Event Rule state. Set to false to disable the sync process."
  type        = bool
  default     = true
}

variable "event_schedule" {
  description = <<-EOT
    AWS Cloudwatch schedule for the sync task. Use cron format "cron(Minutes Hours Day-of-month Month Day-of-week Year)"
    where either `day-of-month` or `day-of-week` must be a question mark, or rate format "rate(15 minutes)".
  EOT
  type        = string
  default     = "cron(*/15 * * * ? *)"
}

variable "sentry_dsn" {
  description = <<-EOT
    Sentry DSN for error logging and alerting. Obtain from Sentry dashboard: Settings - Projects - (project) -
    Client Keys
  EOT
  type        = string
  default     = ""
}

variable "heartbeat_url" {
  description = "The URL of a monitoring service to call after every successful sync"
  type        = string
  default     = ""
}

variable "heartbeat_method" {
  description = "The http method of a monitoring service to call after every successful sync."
  type        = string
  default     = "POST"
}
