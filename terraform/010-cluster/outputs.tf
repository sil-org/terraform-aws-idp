/*
 * VPC outputs
 */
output "db_subnet_group_name" {
  description = "Database subnet group name"
  value       = module.vpc.db_subnet_group_name
}

output "nat_gateway_ip" {
  description = <<-EOT
    IP Address of the NAT gateway. Used to configure the firewall of any external service that uses
    IP-based filtering and needs to be reached by the IdP.
  EOT
  value       = module.vpc.nat_gateway_ip
}

output "private_subnet_ids" {
  description = "List of private subnet ids in VPC"
  value       = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  description = "List of public subnet ids in VPC"
  value       = module.vpc.public_subnet_ids
}

output "vpc_default_sg_id" {
  description = "The default security group ID for the VPC"
  value       = module.vpc.vpc_default_sg_id
}

output "vpc_id" {
  description = "ID for the VPC"
  value       = module.vpc.id
}

output "public_subnet_cidr_blocks" {
  description = <<-EOT
    A list of public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
  EOT
  value       = module.vpc.public_subnet_cidr_blocks
}

output "private_subnet_cidr_blocks" {
  description = <<-EOT
    A list of private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
  EOT
  value       = module.vpc.private_subnet_cidr_blocks
}

/*
 * External application load balancer outputs
 */
output "alb_dns_name" {
  description = "DNS name for ALB"
  value       = module.alb.dns_name
}

output "alb_https_listener_arn" {
  description = "ARN for HTTPS listener on ALB"
  value       = module.alb.https_listener_arn
}

/*
 * Internal application load balancer outputs
 */
output "internal_alb_dns_name" {
  description = "Internal load balancer DNS name"
  value       = module.internal_alb.dns_name
}

output "internal_alb_https_listener_arn" {
  description = "Internal load balancer HTTPS listener ARN"
  value       = module.internal_alb.https_listener_arn
}

/*
 * AWS CloudWatch
 */

output "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.logs.name
}
