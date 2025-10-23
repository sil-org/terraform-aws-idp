variable "secret_salt" {
  description = <<-EOT
    Random string used by SimpleSAMLphp when hashing values such as a generated NameID attribute. A 64-character random
    string will be created automatically if not provided as an input. Specifying the value as an input allows for
    porting the value over from a primary to a secondary workspace. Reference "secret salt" in SimpleSAMLphp
    documentation for more information:
    https://simplesamlphp.org/docs/stable/simplesamlphp-install.html#simplesamlphp-configuration-configphp.
  EOT
  type        = string
  default     = ""
}

variable "memory" {
  description = <<-EOT
    Amount of memory, specified in MB, to allocate to container. This value is used for the "memory" and
    "memoryReservation" container definition parameters.
  EOT
  type        = number
  default     = 96
}

variable "cpu" {
  description = "CPU allocation for the container. Specified in AWS CPU units: 1000 is one CPU"
  type        = number
  default     = 150
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "simplesamlphp"
}

variable "app_env" {
  description = "Application environment, ex: prod, stg, dev, etc."
  type        = string
}

variable "vpc_id" {
  description = "ID for VPC"
  type        = string
}

variable "alb_https_listener_arn" {
  description = "ARN for ALB HTTPS listener"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for SSP IdP"
  type        = string
}

variable "cloudflare_domain" {
  description = "Top level domain name for use with Cloudflare"
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

variable "disable_tls" {
  description = "Set to \"true\" to use HTTP within the VPC"
  type        = bool
  default     = true
}

variable "enable_debug" {
  description = "Enable debug logs."
  type        = bool
  default     = false
}

variable "password_change_url" {
  description = "URL to change password page"
  type        = string
}

variable "password_forgot_url" {
  description = "URL to forgot password page"
  type        = string
}

variable "hub_mode" {
  description = "Whether this IdP is in hub mode, default: false"
  type        = bool
  default     = false
}

variable "id_broker_access_token" {
  description = "Access token for calling id-broker"
  type        = string
}

variable "id_broker_assert_valid_ip" {
  description = "Whether to assert valid ip for calling id-broker"
  type        = bool
  default     = true
}

variable "id_broker_base_uri" {
  description = "Base URL to id-broker API"
  type        = string
}

variable "id_broker_trusted_ip_ranges" {
  description = "List of trusted ip blocks for ID Broker"
  type        = list(string)
  default     = []
}

variable "logging_level" {
  description = <<-EOT
    Minimum log level to output. Allowed values: ERR, WARNING, NOTICE, INFO, DEBUG. Do **not** use DEBUG in production.
  EOT
  type        = string
  default     = "NOTICE"
}

variable "mfa_learn_more_url" {
  description = "URL to learn more about 2SV during profile review."
  type        = string
}

variable "mfa_setup_url" {
  description = "URL to setup MFA"
  type        = string
}

variable "db_name" {
  description = "Name of MySQL database for ssp"
  type        = string
}

variable "mysql_host" {
  description = "Address for RDS instance"
  type        = string
}

variable "mysql_user" {
  description = "MySQL username for id-broker"
  type        = string
}

variable "mysql_pass" {
  description = "MySQL password for id-broker"
  type        = string
}

variable "profile_url" {
  description = "URL of Password Manager profile page"
  type        = string
}

variable "recaptcha_key" {
  description = "Recaptcha site key"
  type        = string
}

variable "recaptcha_secret" {
  description = "Recaptcha secret"
  type        = string
}

variable "remember_me_secret" {
  description = "Secret key used in MFA remember me cookie generation"
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

variable "alb_dns_name" {
  description = "DNS name for application load balancer"
  type        = string
}

variable "idp_name" {
  description = "Short name of IdP for use in logs and email alerts"
  type        = string
}

variable "show_saml_errors" {
  description = "Whether to show SAML errors."
  type        = bool
  default     = false
}

variable "theme_color_scheme" {
  description = "The color scheme to use for SSP."
  type        = string
  default     = "indigo-purple"
}

variable "trusted_ip_addresses" {
  description = "A list of ip addresses or ranges that should not be rate limited"
  type        = list(string)
}

variable "desired_count" {
  description = "Number of instances of the task definition to place and keep running."
  type        = number
  default     = 1
}

variable "analytics_id" {
  description = "The ID used by an analytics provider such as Google Analytics, e.g., \"UA-XXXX-YY\""
  type        = string
}

variable "help_center_url" {
  description = <<-EOT
    Can be set to a URL for an end-user support site. If provided, it will be used as the address for an "I need
    help" link on the IdP login page. If not provided, no link will be shown.
  EOT
  type        = string
}

variable "admin_email" {
  description = "Passed as the SimpleSAMLphp `technicalcontact_email`, which is not used at this time."
  type        = string
}

variable "admin_name" {
  description = "Passed as the SimpleSAMLphp `technicalcontact_name`, which is not used at this time."
  type        = string
}

variable "create_dns_record" {
  description = "Controls creation of a DNS CNAME record for the ECS service."
  type        = bool
  default     = true
}

variable "cduser_username" {
  description = "Username of the Continuous Deployment (CD) IAM user."
  type        = string
}

variable "ssl_ca_base64" {
  description = "Database SSL CA PEM file, base64-encoded"
  type        = string
  default     = ""
}
