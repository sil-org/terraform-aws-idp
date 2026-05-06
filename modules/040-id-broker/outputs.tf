output "hostname" {
  description = "The url to id-broker"
  value       = "${local.subdomain_with_region}.${var.cloudflare_domain}"
}

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.brokerdns.hostname
}

output "access_token_search" {
  description = "Access token for search lambda to use in API calls to id-broker. DEPRECATED: broker search is archived."
  value       = var.create_access_key ? aws_ssm_parameter.access_key.value : data.aws_ssm_parameter.access_key.value
  sensitive   = true
}

output "help_center_url" {
  description = "URL for general user help information"
  value       = var.help_center_url
}

output "email_signature" {
  description = "Text for use as the signature line of emails."
  value       = var.email_signature
}

output "support_email" {
  description = "Email for support."
  value       = var.support_email
}

output "support_name" {
  description = "Name for support."
  value       = var.support_name
}
