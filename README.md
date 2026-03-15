# 📦 terraform-aws-bastion

Terraform module to provision an AWS bastion host in an existing VPC.

The module creates a public EC2 instance, an SSH security group, an EC2 key pair, and a root volume with configurable encryption and size. It is intended to provide a controlled entry point for accessing private resources inside a VPC.

## ⚙️ What This Module Does

- Creates one EC2 bastion host in the first subnet from `public_subnet_ids`
- Creates a security group for SSH access
- Creates an AWS key pair from the provided public key
- Uses an AMI resolved from AWS Systems Manager Parameter Store
- Enforces IMDSv2 on the instance
- Configures the root EBS volume
- Tags the bastion resources with `Environment`

## ⚠️ Important Notes

- This module does not create the VPC or subnets
- The bastion is launched in `public_subnet_ids[0]`, so at least one public subnet ID is required
- `bastion_ssh_ingress_cidrs` is required and should be restricted to trusted sources
- In `prod`, validation blocks `0.0.0.0/0` for `bastion_ssh_ingress_cidrs`
- `instance_type` is validated to the `t3` family only

## 📑 Prerequisites

Before using this module, you should already have:

- An existing VPC
- At least one public subnet
- AWS credentials configured for Terraform
- An SSH public key in a valid `ssh-rsa` or `ssh-ed25519` format

Example key generation:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/bastion_key
```

## 🚀 Quick Start

```hcl
provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source = "./"

  vpc_id                    = "vpc-1234567890abcdef0"
  public_subnet_ids         = ["subnet-1234567890abcdef0"]
  ssh_public_key            = file("${path.module}/bastion_key.pub")
  bastion_ssh_ingress_cidrs = ["203.0.113.10/32"]
  environment               = "dev"
}
```

Run:

```bash
terraform init
terraform plan
terraform apply
```

## 🔐 Security Guidance

- Do not keep `bastion_ssh_ingress_cidrs` open to `0.0.0.0/0` outside disposable test environments
- Use `/32` CIDRs whenever possible
- Keep root volume encryption enabled
- Review any `user_data` passed to the instance
- Prefer remote state and a review process before `apply`

## 📁 Typical Use Case

```text
Internet
    |
    v
Bastion Host (public subnet)
    |
    v
Private Infrastructure
  |- EC2 instances
  |- Databases
  `- Internal services
```

## 🧩 Example

- [Simple example](examples/simple)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.35.1, < 7.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_key_pair.generated_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_security_group.sg_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_bastion_to_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_ssh_bastion_from_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_ssh_ingress_cidrs"></a> [bastion\_ssh\_ingress\_cidrs](#input\_bastion\_ssh\_ingress\_cidrs) | List of CIDR blocks allowed to SSH into the bastion host | `list(string)` | n/a | yes |
| <a name="input_disk_delete_on_termination"></a> [disk\_delete\_on\_termination](#input\_disk\_delete\_on\_termination) | Defines whether the EBS volume will be deleted when the instance is terminated. | `bool` | `true` | no |
| <a name="input_disk_encrypted"></a> [disk\_encrypted](#input\_disk\_encrypted) | Defines whether the EBS volume will be encrypted. | `bool` | `true` | no |
| <a name="input_disk_volume_size"></a> [disk\_volume\_size](#input\_disk\_volume\_size) | The size of the EBS volume in GB | `number` | `20` | no |
| <a name="input_disk_volume_type"></a> [disk\_volume\_type](#input\_disk\_volume\_type) | The type of the EBS volume | `string` | `"gp3"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment tag for resources | `string` | `"dev"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type for the EC2 instances | `string` | `"t3.micro"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix for naming resources | `string` | `"bastion-dev"` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | List of public subnet IDs for the Bastion Host | `list(string)` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key for SSH access to EC2 instances | `string` | n/a | yes |
| <a name="input_ssm_parameter_name"></a> [ssm\_parameter\_name](#input\_ssm\_parameter\_name) | The name of the SSM parameter that contains the AMI ID for the Bastion Host | `string` | `"/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Optional user data script to run on instance launch | `string` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_public_dns"></a> [bastion\_public\_dns](#output\_bastion\_public\_dns) | The public DNS name of the Bastion Host |
| <a name="output_bastion_public_ip"></a> [bastion\_public\_ip](#output\_bastion\_public\_ip) | The public IP address of the Bastion Host |
| <a name="output_bastion_sg_id"></a> [bastion\_sg\_id](#output\_bastion\_sg\_id) | The ID of the Security Group for the Bastion Host |
<!-- END_TF_DOCS -->
