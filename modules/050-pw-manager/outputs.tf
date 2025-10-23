output "ui_hostname" {
  description = "Full hostname for UI"
  value       = local.ui_hostname
}

output "api_public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.apidns_intermediate.hostname
}
