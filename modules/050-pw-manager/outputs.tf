output "ui_hostname" {
  description = "Full hostname for UI"
  value       = local.ui_hostname
}

output "api_public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = "${cloudflare_dns_record.apidns_intermediate.name}.${var.cloudflare_domain}"
}
