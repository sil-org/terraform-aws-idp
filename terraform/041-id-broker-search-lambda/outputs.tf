output "function_arn" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = aws_lambda_function.search.arn
}

output "role_arn_for_remote_execution" {
  description = "DEPRECATED: may be removed in the next major version."
  value       = aws_iam_role.assumeRole.arn
}
