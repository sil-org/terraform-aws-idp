output "admin_pass" {
  description = "SSP Admin password"
  value       = random_id.admin_pass.hex
}

output "secret_salt" {
  description = <<-EOT
    Random string used by SimpleSAMLphp when hashing values such as a generated NameID attribute. Reference
    "secret salt" in SimpleSAMLphp documentation for more information:
    https://simplesamlphp.org/docs/stable/simplesamlphp-install.html#simplesamlphp-configuration-configphp.
  EOT
  value       = local.secret_salt
  sensitive   = true
}

output "public_dns_value" {
  description = "The value to use for the 'public' DNS record, if creating it outside of this module."
  value       = cloudflare_record.sspdns_intermediate.hostname
}
