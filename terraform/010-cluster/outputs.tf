/*
 * VPC outputs
 */
output "db_subnet_group_name" {
  value = module.vpc.db_subnet_group_name
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "vpc_default_sg_id" {
  value = module.vpc.vpc_default_sg_id
}

output "vpc_id" {
  value = module.vpc.id
}

output "public_subnet_cidr_blocks" {
  value = module.vpc.public_subnet_cidr_blocks
}

output "private_subnet_cidr_blocks" {
  value = module.vpc.private_subnet_cidr_blocks
}

/*
 * External application load balancer outputs
 */
output "alb_dns_name" {
  value = module.alb.dns_name
}

output "alb_https_listener_arn" {
  value = module.alb.https_listener_arn
}

/*
 * Internal application load balancer outputs
 */
output "internal_alb_dns_name" {
  value = module.internal_alb.dns_name
}

output "internal_alb_https_listener_arn" {
  value = module.internal_alb.https_listener_arn
}

/*
 * AWS CloudWatch
 */

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.logs.name
}
