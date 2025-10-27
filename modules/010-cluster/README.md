# Terraform module for IdP Cluster

This module is used to set up the cluster with VPC, security groups, auto-scaling group,
ssl certificate, core application load balancer, and a CloudWatch log group

## What this does

 - Create VPC named after `app_name` and `app_env`
 - Create security group to allow traffic from Cloudflare IPs
 - Create auto scaling group of defined size and distribute instances across `aws_zones`
 - Locate ACM certificate for use in ALB listeners
 - Create application load balancer (ALB)
 - Create CloudWatch log group
 - Optionally create a Cloudwatch dashboard
 - Optionally create a NAT gateway

## Required Inputs

 - `app_name` - Name of application, ex: Doorman, IdP, etc.
 - `app_env` - Name of environment, ex: prod, test, etc.
 - `aws_instance` - A map containing keys for `instance_type`, `volume_size`, `instance_count`
 - `aws_zones` - A list of availability zones to distribute instances across, example: `["us-east-1a", "us-east-1b", "us-east-1c"]`
 - `cert_domain_name` - Domain name for certificate, example: `*.mydomain.com`
 - `ecs_cluster_name` - ECS cluster name for registering instances
 - `ecs_instance_profile_id` - IAM profile ID for ecsInstanceProfile
 - `idp_name` - Name of the IDP (all lowercase, no spaces), example: `acme`

## Optional Inputs

- `ami_name_filter` - Filter list to identify the EC2 AMI to be used in the autoscaling group. default `["amzn2-ami-ecs-hvm-*-x86_64-ebs"]`
- `create_nat_gateway` - default `true`
- `disable_public_ipv4` - Set to true to remove the public IPv4 addresses from the ALB. Requires enable_ipv6 = true.
- `enable_ipv6` - Set to true to enable IPv6 in the ALB and VPC
- `private_subnet_cidr_blocks`
- `public_subnet_cidr_blocks`
- `vpc_cidr_block`
- `log_retention_in_days` - Number of days to retain CloudWatch application logs (default=30)

## Outputs

 - `db_subnet_group_name` - Database subnet group name
 - `nat_gateway_ip` - IP Address of the NAT gateway
 - `private_subnet_ids` - List of private subnet ids in VPC
 - `private_subnet_cidr_blocks` - A list of private subnet CIDR blocks, ex: `["10.0.11.0/24","10.0.22.0/24"]`
 - `public_subnet_ids` - List of public subnet ids in VPC
 - `public_subnet_cidr_blocks` - A list of public subnet CIDR blocks, ex: `["10.0.10.0/24","10.0.12.0/24"]`
 - `vpc_default_sg_id` - The default security group ID for the VPC
 - `vpc_id` - ID for the VPC
 - `alb_dns_name` - DNS name for ALB
 - `alb_https_listener_arn` - ARN for HTTPS listener on ALB
 - `cloudwatch_log_group_name` - Name of the CloudWatch log group
 
## Example Usage

```hcl
module "cluster" {
  source                  = "github.com/sil-org/idp-in-a-box//terraform/010-cluster"
  app_name                = var.app_name
  app_env                 = var.app_env
  aws_instance            = var.aws_instance
  aws_zones               = var.aws_zones
  cert_domain_name        = var.cert_domain_name
  ecs_cluster_name        = data.terraform_remote_state.core.ecs_cluster_name
  ecs_instance_profile_id = data.terraform_remote_state.core.ecs_instance_profile_id
  idp_name                = var.idp_name
}
```
