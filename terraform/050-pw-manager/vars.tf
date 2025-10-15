variable "alb_dns_name" {
  description = "DNS name for application load balancer"
  type        = string
}

variable "alb_https_listener_arn" {
  description = "ARN for ALB HTTPS listener"
  type        = string
}

variable "alerts_email" {
  description = "Email address to send alerts/notifications. Must be specified if `alerts_email_enabled` is true."
  type        = string
  default     = ""
}

variable "alerts_email_enabled" {
  description = "Set to true to disable email alerts."
  type        = bool
  default     = true
}

variable "api_subdomain" {
  description = "Subdomain for pw manager api"
  type        = string
}

variable "app_env" {
  description = "Application environment"
  type        = string
}

variable "app_name" {
  description = "Used in ECS service names and logs, best to leave as default."
  type        = string
  default     = "pw-manager"
}

variable "auth_saml_checkResponseSigning" {
  description = "Whether to check response for signature."
  type        = bool
  default     = true
}

variable "auth_saml_idp_url" {
  description = "Base URL of the IdP, e.g. \"https://login.example.com\""
  type        = string
  default     = ""
}

variable "auth_saml_idpCertificate" {
  description = "Public cert data for IdP"
  type        = string
}

variable "auth_saml_requireEncryptedAssertion" {
  type    = bool
  default = true
}

variable "auth_saml_signRequest" {
  description = "Whether or not to sign auth requests"
  type        = bool
  default     = true
}

variable "auth_saml_spCertificate" {
  description = "Public cert data for this SP"
  type        = string
}

variable "auth_saml_spPrivateKey" {
  description = "Private cert data for this SP"
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

variable "code_length" {
  description = "Number of digits in reset code."
  type        = number
  default     = 6
}

variable "cpu" {
  description = "Amount of CPU to allocate to container."
  type        = number
  default     = 64
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "db_name" {
  description = "Name of MySQL database for pw-api"
  type        = string
}

variable "desired_count" {
  description = "Number of API tasks that should be run"
  type        = number
  default     = 1
}

variable "docker_image" {
  description = "URL to Docker image"
  type        = string
}

variable "ecs_cluster_id" {
  description = "ID for ECS Cluster"
  type        = string
}

variable "ecsServiceRole_arn" {
  description = "ARN for ECS Service Role"
  type        = string
}

variable "email_signature" {
  description = "Email signature line"
  type        = string
}

variable "extra_hosts" {
  description = "Extra hosts for the API task definition, e.g. [\"host.example.com:192.168.1.1\"]"
  type        = string
  default     = "null"
}

variable "help_center_url" {
  type = string
}

variable "id_broker_access_token" {
  description = "Access token for calling id-broker"
  type        = string
}

variable "id_broker_assertValidBrokerIp" {
  description = "Whether to assert IP address for ID Broker API is trusted"
  type        = bool
  default     = true
}

variable "id_broker_base_uri" {
  description = "Base URL to id-broker API"
  type        = string
}

variable "id_broker_validIpRanges" {
  description = "List of valid IP ranges to ID Broker API"
  type        = list(string)
}

variable "idp_display_name" {
  description = "Display name of IdP for UI, something like 'ACME Inc.'"
  type        = string
}

variable "idp_name" {
  description = "Short name of IdP for logs, something like 'acme'"
  type        = string
}

variable "memory" {
  description = "Amount of memory to allocate to container."
  type        = number
  default     = 100
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

variable "password_rule_alpha_and_numeric" {
  description = "require alpha and numeric characters in password, use \"false\" or \"true\" strings"
  type        = bool
  default     = false
}

variable "password_rule_enablehibp" {
  description = "enable haveibeenpwned.com password check"
  type        = bool
  default     = true
}

variable "password_rule_maxlength" {
  description = "maximum password length"
  type        = number
  default     = 255
}

variable "password_rule_minlength" {
  description = "minimum password length"
  type        = number
  default     = 10
}

variable "password_rule_minscore" {
  description = "minimum password score"
  type        = number
  default     = 3
}

variable "recaptcha_key" {
  description = "Recaptcha site key"
  type        = string
}

variable "recaptcha_secret" {
  description = "Recaptcha secret"
  type        = string
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

variable "support_email" {
  description = "Email address for end user support, displayed on PW UI and in emails"
  type        = string
}

variable "support_name" {
  description = "Name for end user support, displayed on PW UI and in emails"
  type        = string
}

variable "support_phone" {
  description = "Phone number for end user support, displayed on PW UI"
  type        = string
}

variable "support_url" {
  description = "URL for end user support, displayed on PW UI"
  type        = string
}

variable "ui_subdomain" {
  description = "Subdomain for PW UI"
  type        = string
}

variable "vpc_id" {
  description = "ID for VPC"
  type        = string
}
