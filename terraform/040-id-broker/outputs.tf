output "hostname" {
  description = "The url to id-broker"
  value       = "${local.subdomain_with_region}.${var.cloudflare_domain}"
}

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.brokerdns.hostname
}

output "access_token_pwmanager" {
  description = "Access token for PW Manager to use in API calls to id-broker"
  value       = var.output_alternate_tokens ? random_id.access_token_pwmanager_b.hex : random_id.access_token_pwmanager.hex
}

output "access_token_search" {
  description = "Access token for search lambda to use in API calls to id-broker"
  value       = var.output_alternate_tokens ? random_id.access_token_search_b.hex : random_id.access_token_search.hex
}

output "access_token_ssp" {
  description = "Access token for simpleSAMLphp to use in API calls to id-broker"
  value       = var.output_alternate_tokens ? random_id.access_token_ssp_b.hex : random_id.access_token_ssp.hex
}

output "access_token_idsync" {
  description = "Access token for id-sync to use in API calls to id-broker"
  value       = var.output_alternate_tokens ? random_id.access_token_idsync_b.hex : random_id.access_token_idsync.hex
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
