output "cron_schedule" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = local.event_schedule
}

output "event_schedule" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = local.event_schedule
}

output "s3_bucket_name" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = aws_s3_bucket.backup.bucket
}

output "s3_bucket_arn" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = aws_s3_bucket.backup.arn
}
