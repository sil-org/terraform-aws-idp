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

## Terraform Registry

See the [Terraform Registry](https://registry.terraform.io/modules/sil-org/idp/aws/latest/submodules/010-cluster) for usage documentation.

## Example Usage

```hcl
module "cluster" {
  source  = "sil-org/idp/aws//modules/010-cluster"
  version = "~> 14.0" # This version number is an example only. Use the latest available."

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
