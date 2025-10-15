variable "abandoned_user_abandoned_period" {
  type    = string
  default = "+6 months"
}

variable "abandoned_user_best_practice_url" {
  type    = string
  default = ""
}

variable "abandoned_user_deactivate_instructions_url" {
  type    = string
  default = ""
}

variable "app_env" {
  type        = string
  description = "Environment name, ex: 'stg' or 'prod'"
}

variable "app_name" {
  type        = string
  default     = "id-broker"
  description = "Used in ECS service names and logs, best to leave as default."
}

variable "cduser_username" {
  type    = string
  default = "IAM user name for the CD user. Used to create ECS deployment policy."
}

variable "cloudflare_domain" {
  type = string
}

variable "cloudwatch_log_group_name" {
  type = string
}

variable "contingent_user_duration" {
  type    = string
  default = "+4 weeks"
}

variable "cpu" {
  type        = number
  description = "Amount of CPU to allocate to container, recommend '250' for production"
  default     = 250
}

variable "cpu_cron" {
  type        = number
  description = "Amount of CPU to allocate to cron container, recommend '128' for production"
  default     = 128
}

variable "cpu_email" {
  type        = number
  description = "Amount of CPU to allocate to email container"
  default     = 64
}

variable "db_name" {
  type = string
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "docker_image" {
  type = string
}

variable "ecs_cluster_id" {
  type = string
}

variable "ecsServiceRole_arn" {
  type = string
}

variable "email_repeat_delay_days" {
  type    = number
  default = 31
}

variable "email_brand_color" {
  description = <<EOT
    The CSS color to use for branding in emails (e.g. `rgb(0, 93, 154)`). Required for idp-id-broker
    version 8.0.0 or higher.
  EOT
  type        = string
  default     = ""
}

variable "email_brand_logo" {
  description = <<EOT
    The fully qualified URL to an image for use as logo in emails. Required for idp-id-broker version
    8.0.0 or higher.
  EOT
  type        = string
  default     = ""
}

variable "email_signature" {
  type    = string
  default = ""
}

variable "event_schedule" {
  type    = string
  default = "cron(0 0 * * ? *)"
}

variable "from_email" {
  description = "Email address provided on the FROM header of email notifications."
  type        = string
}

variable "from_name" {
  description = "Email address provided on the FROM header of email notifications."
  type        = string
  default     = ""
}

variable "google_config" {
  description = "A map of Google properties for Sheets export"
  type        = map(string)
  default     = { enableSheetsExport = false }
}

variable "help_center_url" {
  type = string
}

variable "hibp_check_interval" {
  type    = string
  default = "+1 week"
}

variable "hibp_check_on_login" {
  type    = bool
  default = true
}

variable "hibp_grace_period" {
  type    = string
  default = "+1 week"
}

variable "hibp_tracking_only" {
  type    = bool
  default = false
}

variable "hibp_notification_bcc" {
  type    = string
  default = ""
}

variable "hr_notifications_email" {
  type    = string
  default = ""
}

variable "idp_display_name" {
  type    = string
  default = ""
}

variable "idp_name" {
  description = "Short name of IdP for logs, something like 'acme'"
  type        = string
}

variable "inactive_user_period" {
  type    = string
  default = "+18 months"
}

variable "inactive_user_deletion_enable" {
  type    = bool
  default = false
}

variable "alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's external Application Load Balancer."
  type        = string
  default     = ""
}

variable "alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's external ALB's listener."
  type        = string
  default     = ""
}

variable "internal_alb_dns_name" {
  description = "The DNS name for the IdP-in-a-Box's internal Application Load Balancer."
  type        = string
  default     = ""
}

variable "internal_alb_listener_arn" {
  description = "The ARN for the IdP-in-a-Box's internal ALB's listener."
  type        = string
  default     = ""
}

variable "invite_email_delay_seconds" {
  type    = number
  default = 0
}

variable "invite_grace_period" {
  type    = string
  default = "+3 months"
}

variable "invite_lifespan" {
  type    = string
  default = "+1 month"
}

variable "lost_security_key_email_days" {
  type    = number
  default = 62
}

variable "memory" {
  type        = number
  description = "Amount of memory to allocate to container, recommend '200' for production"
  default     = 200
}

variable "memory_cron" {
  type        = number
  description = "Amount of memory to allocate to cron container, recommend '200' for more than 500 active users"
  default     = 200
}

variable "memory_email" {
  type        = number
  description = "Amount of memory to allocate to email container"
  default     = 64
}

variable "method_add_interval" {
  type    = string
  default = "+6 months"
}

variable "method_codeLength" {
  type    = number
  default = 6
}

variable "method_gracePeriod" {
  type    = string
  default = "+15 days"
}

variable "method_lifetime" {
  type    = string
  default = "+5 days"
}

variable "method_maxAttempts" {
  type    = number
  default = 10
}

variable "mfa_add_interval" {
  type    = string
  default = "+30 days"
}

variable "mfa_allow_disable" {
  type    = bool
  default = true
}

variable "mfa_api_base_url" {
  description = "The base URL of the MFA API. Must include the scheme and a trailing slash."
  type        = string
  default     = ""
}

variable "mfa_lifetime" {
  type    = string
  default = "+2 hours"
}

variable "mfa_manager_bcc" {
  type    = string
  default = ""
}

variable "mfa_manager_help_bcc" {
  type    = string
  default = ""
}

variable "mfa_required_for_new_users" {
  type    = bool
  default = false
}

variable "rp_origins" {
  type = string
}

variable "minimum_backup_codes_before_nag" {
  type    = number
  default = 4
}

variable "mysql_host" {
  type = string
}

variable "mysql_pass" {
  type = string
}

variable "mysql_user" {
  type = string
}

variable "notification_email" {
  description = "Email address to send notifications to"
  type        = string
}

variable "password_expiration_grace_period" {
  type    = string
  default = "+30 days"
}

variable "password_lifespan" {
  type    = string
  default = "+1 year"
}

variable "password_mfa_lifespan_extension" {
  type    = string
  default = "+4 years"
}

variable "password_profile_url" {
  type = string
}

variable "password_reuse_limit" {
  type    = number
  default = 10
}

variable "profile_review_interval" {
  type    = string
  default = "+12 months"
}

variable "run_task" {
  type    = string
  default = "cron/all"
}

variable "send_get_backup_codes_emails" {
  type    = bool
  default = true
}

variable "send_invite_emails" {
  type    = bool
  default = true
}

variable "send_lost_security_key_emails" {
  type    = bool
  default = true
}

variable "send_method_purged_emails" {
  type    = bool
  default = true
}

variable "send_method_reminder_emails" {
  type    = bool
  default = true
}

variable "send_mfa_disabled_emails" {
  type    = bool
  default = true
}

variable "send_mfa_enabled_emails" {
  type    = bool
  default = true
}

variable "send_mfa_option_added_emails" {
  type    = bool
  default = true
}

variable "send_mfa_option_removed_emails" {
  type    = bool
  default = true
}

variable "send_mfa_rate_limit_emails" {
  type    = bool
  default = true
}

variable "send_password_changed_emails" {
  type    = bool
  default = true
}

variable "send_password_expired_emails" {
  type    = bool
  default = true
}

variable "send_password_expiring_emails" {
  type    = bool
  default = true
}

variable "send_refresh_backup_codes_emails" {
  type    = bool
  default = true
}

variable "send_welcome_emails" {
  type    = bool
  default = true
}

variable "sentry_dsn" {
  description = "Sentry DSN for error logging and alerting"
  type        = string
  default     = ""
}

variable "subdomain" {
  description = "The subdomain for id-broker, without an embedded region in it (e.g. 'broker', NOT 'broker-us-east-1')"
  type        = string
}

variable "subject_for_abandoned_users" {
  type    = string
  default = ""
}

variable "subject_for_get_backup_codes" {
  type    = string
  default = ""
}

variable "subject_for_invite" {
  type    = string
  default = ""
}

variable "subject_for_lost_security_key" {
  type    = string
  default = ""
}

variable "subject_for_method_purged" {
  type    = string
  default = ""
}

variable "subject_for_method_reminder" {
  type    = string
  default = ""
}

variable "subject_for_method_verify" {
  type    = string
  default = ""
}

variable "subject_for_mfa_disabled" {
  type    = string
  default = ""
}

variable "subject_for_mfa_enabled" {
  type    = string
  default = ""
}

variable "subject_for_mfa_manager" {
  type    = string
  default = ""
}

variable "subject_for_mfa_manager_help" {
  type    = string
  default = ""
}

variable "subject_for_mfa_option_added" {
  type    = string
  default = ""
}

variable "subject_for_mfa_option_removed" {
  type    = string
  default = ""
}

variable "subject_for_mfa_rate_limit" {
  type    = string
  default = ""
}

variable "subject_for_password_changed" {
  type    = string
  default = ""
}

variable "subject_for_password_expired" {
  type    = string
  default = ""
}

variable "subject_for_password_expiring" {
  type    = string
  default = ""
}

variable "subject_for_refresh_backup_codes" {
  type    = string
  default = ""
}

variable "subject_for_welcome" {
  type    = string
  default = ""
}

variable "support_email" {
  type = string
}

variable "support_name" {
  type    = string
  default = "support"
}

variable "vpc_id" {
  type = string
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "output_alternate_tokens" {
  description = "Output alternate tokens for client services. Used for token rotation."
  type        = bool
  default     = false
}

variable "ssl_ca_base64" {
  description = "Database SSL CA PEM file, base64-encoded"
  type        = string
  default     = ""
}
