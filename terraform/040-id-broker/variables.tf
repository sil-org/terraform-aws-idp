variable "abandoned_user_abandoned_period" {
  description = "Time a user record can remain abandoned before HR is notified."
  type        = string
  default     = "+6 months"
}

variable "abandoned_user_best_practice_url" {
  description = "URL for best practices, referenced in notification email."
  type        = string
  default     = ""
}

variable "abandoned_user_deactivate_instructions_url" {
  description = "URL for instruction on how to deactivate user accounts, referenced in notification email."
  type        = string
  default     = ""
}

variable "app_env" {
  description = "Environment name, ex: 'stg' or 'prod'"
  type        = string
}

variable "app_name" {
  description = "Used in ECS service names and logs, best to leave as default."
  type        = string
  default     = "id-broker"
}

variable "cd_principal_arn" {
  description = "The ARN of the user or role that will push images to ECR for this service."
  type        = string
}

variable "cduser_username" {
  type    = string
  default = "IAM user name for the CD user. Used to create ECS deployment policy."
}

variable "cloudflare_domain" {
  description = "Top level domain name for use with Cloudflare"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "contingent_user_duration" {
  description = "How long before a new user without a primary email address expires."
  type        = string
  default     = "+4 weeks"
}

variable "cpu" {
  description = <<-EOT
    Amount of CPU (AWS CPU units, 1000 = 1 cpu) to allocate to primary container.
  EOT
  type        = number
  default     = 250
}

variable "cpu_cron" {
  description = "Amount of CPU (AWS CPU units, 1000 = 1 cpu) to allocate to cron container."
  type        = number
  default     = 128
}

variable "cpu_email" {
  description = "Amount of CPU (AWS CPU units, 1000 = 1 cpu) to allocate to email container"
  type        = number
  default     = 64
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Name of MySQL database for id-broker"
  type        = string
}

variable "desired_count" {
  description = "Desired count of tasks running in ECS service"
  type        = number
  default     = 1
}

variable "docker_image" {
  type = string
}


variable "ecs_cluster_id" {
  description = "ID for ECS Cluster"
  type        = string
}

variable "ecs_instance_role_arn" {
  description = "The ARN of the role that will be passed to ECS and ECR as the instance role."
  type        = string
}

variable "ecsServiceRole_arn" {
  description = "ARN for ECS Service Role"
  type        = string
}

variable "email_repeat_delay_days" {
  description = "Don't resend the same type of email to the same user for X days."
  type        = number
  default     = 31
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
  description = "Signature for use in emails. Default is empty string"
  type        = string
  default     = ""
}

variable "event_schedule" {
  description = <<-EOT
    AWS EventBridge schedule for the task defined by the "run_task variable. Use cron format "cron(Minutes Hours
    Day-of-month Month Day-of-week Year)" where either `day-of-month` or `day-of-week` must be a question mark, or
    rate format "rate(15 minutes)".
  EOT
  type        = string
  default     = "cron(0 0 * * ? *)"
}

variable "from_email" {
  description = "Email address provided on the FROM header of email notifications."
  type        = string
  default     = ""
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
  description = "URL to password manager help center"
  type        = string
}

variable "hibp_check_interval" {
  description = "How often should HIBP be checked during login."
  type        = string
  default     = "+1 week"
}

variable "hibp_check_on_login" {
  description = "Whether to check HIBP during login."
  type        = bool
  default     = true
}

variable "hibp_grace_period" {
  description = "How long to set grace period when a pwned password is discovered and force expired."
  type        = string
  default     = "+1 week"
}

variable "hibp_tracking_only" {
  description = "Whether to actually apply changes or just track when pwned passwords are discovered."
  type        = bool
  default     = false
}

variable "hibp_notification_bcc" {
  description = "An optional email address to BCC pwned password alert emails to."
  type        = string
  default     = ""
}

variable "hr_notifications_email" {
  description = "If this is defined, HR notification emails (e.g. abandoned user account) will be sent here."
  type        = string
  default     = ""
}

variable "idp_display_name" {
  description = "Display name for IdP."
  type        = string
  default     = ""
}

variable "idp_name" {
  description = "Short name of IdP for logs and email alerts, something like 'acme'"
  type        = string
}

variable "inactive_user_period" {
  description = "Time a user record can remain inactive before being deleted."
  type        = string
  default     = "+18 months"
}

variable "inactive_user_deletion_enable" {
  description = "Enable deletion of inactive users after a period defined by inactive_user_period."
  type        = bool
  default     = false
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
  description = <<-EOT
    The DNS name for the IdP-in-a-Box's internal Application Load Balancer. This can be omitted if `alb_dns_name` is
    provided.
  EOT
  type        = string
  default     = ""
}

variable "internal_alb_listener_arn" {
  description = <<-EOT
    The ARN for the IdP-in-a-Box's internal ALB's listener. This can be omitted if `alb_listener_arn` is
    provided.
  EOT
  type        = string
  default     = ""
}

variable "invite_email_delay_seconds" {
  description = "How long to delay new user invite email."
  type        = number
  default     = 0
}

variable "invite_grace_period" {
  description = "Grace period after the invite lifespan, after which the invite will be deleted."
  type        = string
  default     = "+3 months"
}

variable "invite_lifespan" {
  description = "Time span before the invite code expires."
  type        = string
  default     = "+1 month"
}

variable "lost_security_key_email_days" {
  description = "The number of days of not using a security key after which we email the user."
  type        = number
  default     = 62
}

variable "memory" {
  description = "Amount of memory to allocate to primary container."
  type        = number
  default     = 200
}

variable "memory_cron" {
  description = "Amount of memory to allocate to cron container."
  type        = number
  default     = 200
}

variable "memory_email" {
  description = "Amount of memory to allocate to email container"
  type        = number
  default     = 64
}

variable "method_add_interval" {
  description = "Interval between reminders to add recovery methods."
  type        = string
  default     = "+6 months"
}

variable "method_codeLength" {
  description = "Number of digits in recovery method verification code."
  type        = number
  default     = 6
}

variable "method_gracePeriod" {
  description = "If a recovery method has been expired longer than this amount of time, it will be removed."
  type        = string
  default     = "+15 days"
}

variable "method_lifetime" {
  description = "Defines the amount of time in which a recovery method must be verified."
  type        = string
  default     = "+5 days"
}

variable "method_maxAttempts" {
  description = "Maximum number of recovery method verification attempts allowed."
  type        = number
  default     = 10
}

variable "mfa_add_interval" {
  description = "Interval between reminders to add MFAs."
  type        = string
  default     = "+30 days"
}

variable "mfa_allow_disable" {
  description = "If false, `require_mfa` cannot be set to \"no\" for any user."
  type        = bool
  default     = true
}

variable "mfa_api_base_url" {
  description = "The base URL of the MFA API. Must include the scheme and a trailing slash."
  type        = string
  default     = ""
}

variable "mfa_lifetime" {
  description = "Defines the amount of time in which an MFA must be verified."
  type        = string
  default     = "+2 hours"
}

variable "mfa_manager_bcc" {
  description = "Email address to bcc on the manager mfa email."
  type        = string
  default     = ""
}

variable "mfa_manager_help_bcc" {
  description = "Email address to bcc on the manager mfa help email."
  type        = string
  default     = ""
}

variable "mfa_required_for_new_users" {
  description = "Require MFA for all new users."
  type        = bool
  default     = false
}

variable "rp_origins" {
  description = "CSV list of allowed Webauthn Relying Party Origins"
  type        = string
}

variable "minimum_backup_codes_before_nag" {
  description = "Nag the user if they have FEWER than this number of backup codes."
  type        = number
  default     = 4
}

variable "mysql_host" {
  description = "Address for RDS instance"
  type        = string
}

variable "mysql_pass" {
  description = "MySQL password for id-broker"
  type        = string
}

variable "mysql_user" {
  description = "MySQL username for id-broker"
  type        = string
}

variable "notification_email" {
  description = "Email address to send alerts/notifications to"
  type        = string
}

variable "output_alternate_tokens" {
  description = "Output alternate tokens for client services. Used for token rotation."
  type        = bool
  default     = false
}

variable "password_expiration_grace_period" {
  description = "Grace period after `password_lifespan` after which the account will be locked."
  type        = string
  default     = "+30 days"
}

variable "password_lifespan" {
  description = "Time span before which the user should set a new password."
  type        = string
  default     = "+1 year"
}

variable "password_mfa_lifespan_extension" {
  description = "Extension to password lifespan for users with at least one 2-step Verification option."
  type        = string
  default     = "+4 years"
}

variable "password_profile_url" {
  description = "URL to password manager profile"
  type        = string
}

variable "password_reuse_limit" {
  description = "Number of passwords to remember for \"recent password\" restriction."
  type        = number
  default     = 10
}

variable "profile_review_interval" {
  description = "Interval between reminders to review."
  type        = string
  default     = "+12 months"
}

variable "run_task" {
  description = "Task to run on the schedule defined by `event_schedule`."
  type        = string
  default     = "cron/all"
}

variable "send_get_backup_codes_emails" {
  description = "Bool of whether to send get backup codes emails."
  type        = bool
  default     = true
}

variable "send_invite_emails" {
  description = "Bool of whether to send invite emails."
  type        = bool
  default     = true
}

variable "send_lost_security_key_emails" {
  description = "Bool of whether to send lost security key emails."
  type        = bool
  default     = true
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
  description = "Bool of whether to send mfa disabled emails."
  type        = bool
  default     = true
}

variable "send_mfa_enabled_emails" {
  description = "Bool of whether to send mfa enabled emails."
  type        = bool
  default     = true
}

variable "send_mfa_option_added_emails" {
  description = "Bool of whether to send mfa option added emails."
  type        = bool
  default     = true
}

variable "send_mfa_option_removed_emails" {
  description = "Bool of whether to send mfa option removed emails."
  type        = bool
  default     = true
}

variable "send_mfa_rate_limit_emails" {
  description = "Bool of whether to send MFA rate limit emails."
  type        = bool
  default     = true
}

variable "send_password_changed_emails" {
  description = "Bool of whether to send password changed emails."
  type        = bool
  default     = true
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
  description = "Bool of whether to send refresh backup codes emails."
  type        = bool
  default     = true
}

variable "send_welcome_emails" {
  description = "Bool of whether to send welcome emails."
  type        = bool
  default     = true
}

variable "sentry_dsn" {
  description = <<-EOT
    Sentry DSN for error logging and alerting. Obtain from Sentry dashboard: Settings - Projects - (project) -
    Client Keys
  EOT
  type        = string
  default     = ""
}

variable "ssl_ca_base64" {
  description = "Database SSL CA PEM file, base64-encoded"
  type        = string
  default     = ""
}

variable "subdomain" {
  description = "The subdomain for id-broker, without an embedded region in it (e.g. 'broker', NOT 'broker-us-east-1')"
  type        = string
}

variable "subject_for_abandoned_users" {
  description = "Email subject text for abandoned user emails."
  type        = string
  default     = ""
}

variable "subject_for_get_backup_codes" {
  description = "Email subject text for get backup codes emails."
  type        = string
  default     = ""
}

variable "subject_for_invite" {
  description = "Email subject text for invite emails."
  type        = string
  default     = ""
}

variable "subject_for_lost_security_key" {
  description = "Email subject text for lost security key emails."
  type        = string
  default     = ""
}

variable "subject_for_method_purged" {
  description = "Email subject text for method purged emails."
  type        = string
  default     = ""
}

variable "subject_for_method_reminder" {
  description = "Email subject text for method reminder emails."
  type        = string
  default     = ""
}

variable "subject_for_method_verify" {
  description = "Email subject text for method verify emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_disabled" {
  description = "Email subject text for MFA disabled emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_enabled" {
  description = "Email subject text for MFA enabled emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_manager" {
  description = "Email subject text for MFA manager emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_manager_help" {
  description = "Email subject text for MFA manager help emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_option_added" {
  description = "Email subject text for MFA option added emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_option_removed" {
  description = "Email subject text for MFA option removed emails."
  type        = string
  default     = ""
}

variable "subject_for_mfa_rate_limit" {
  description = "Email subject text for MFA rate limit emails."
  type        = string
  default     = ""
}

variable "subject_for_password_changed" {
  description = "Email subject text for password changed emails."
  type        = string
  default     = ""
}

variable "subject_for_password_expired" {
  description = "Email subject text for password expired emails."
  type        = string
  default     = ""
}

variable "subject_for_password_expiring" {
  description = "Email subject text for password expiring emails."
  type        = string
  default     = ""
}

variable "subject_for_refresh_backup_codes" {
  description = "Email subject text for refresh backup codes emails."
  type        = string
  default     = ""
}

variable "subject_for_welcome" {
  description = "Email subject text for welcome emails."
  type        = string
  default     = ""
}

variable "support_email" {
  description = "Email address for support"
  type        = string
}

variable "support_name" {
  description = "Name for support."
  type        = string
  default     = "support"
}

variable "vpc_id" {
  description = "ID for VPC"
  type        = string
}
