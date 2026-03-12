# 📦 terraform-aws-bastion

Terraform module to provision a **secure Bastion Host on AWS**, enabling controlled SSH access to resources inside a VPC.

This module creates a Bastion EC2 instance in a **public subnet**, configured with a **security group allowing SSH access only from trusted CIDR blocks**.

It is designed to provide a **simple and secure entry point** for administrators to access private infrastructure (e.g., private EC2 instances, RDS databases, or internal services).

---

## 🚀 Features

This module provisions:

* EC2 Bastion Host
* Security Group with restricted SSH access
* Outbound internet access for updates and package installation
* SSH Key Pair creation
* Root EBS volume configuration
* IMDSv2 enforcement (instance metadata security)
* AMI lookup via **SSM Parameter Store**

---

## 🧱 Resources Created

The module creates the following AWS resources:

* `aws_instance` – Bastion Host EC2 instance
* `aws_security_group` – Bastion security group
* `aws_security_group_rule` – SSH ingress rule and outbound rule
* `aws_key_pair` – SSH key pair for access
* `aws_ssm_parameter` (data source) – Retrieves latest AMI

---

## 🔐 Security Considerations

This module follows several security best practices:

* SSH access restricted to **trusted CIDR ranges**
* **IMDSv2 enforced**
* Bastion deployed in a **public subnet only**
* Security group rules defined separately for clarity
* Sensitive credentials are **not hardcoded**

---

## 📁 Typical Use Case

This module is useful when you need a **secure jump host** to access private resources inside a VPC:

```
Internet
    │
    ▼
Bastion Host (Public Subnet)
    │
    ▼
Private Infrastructure
 ├─ EC2 instances
 ├─ Databases
 └─ Internal services
```

---

## 🧩 Example Usage

[Simple Example](examples/simple)


---

## ⚠️ Best Practices

Always:

* Run `terraform plan` before `terraform apply`
* Restrict `bastion_ssh_ingress_cidrs` to **specific IPs**
* Store Terraform code in **version control**
* Consider using **remote state** (S3 + DynamoDB) for team environments




<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.35.1 |

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
| <a name="input_bastion_ssh_ingress_cidrs"></a> [bastion\_ssh\_ingress\_cidrs](#input\_bastion\_ssh\_ingress\_cidrs) | List of CIDR blocks allowed to SSH into the bastion host | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
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