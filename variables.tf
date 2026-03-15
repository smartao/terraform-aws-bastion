variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the Bastion Host"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) > 0
    error_message = "VALIDATION: public_subnet_ids must contain at least one public subnet ID."
  }
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = "dev"
}

variable "bastion_ssh_ingress_cidrs" {
  description = "List of CIDR blocks allowed to SSH into the bastion host"
  type        = list(string)

  validation {
    condition     = length(var.bastion_ssh_ingress_cidrs) > 0
    error_message = "VALIDATION: bastion_ssh_ingress_cidrs must contain at least one trusted CIDR."
  }

  validation {
    condition = alltrue([
      for cidr in var.bastion_ssh_ingress_cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "VALIDATION: bastion_ssh_ingress_cidrs must contain only valid IPv4 or IPv6 CIDR blocks."
  }

  validation {
    condition = (
      !contains(["prod", "production"], lower(trimspace(var.environment))) ||
      !contains(var.bastion_ssh_ingress_cidrs, "0.0.0.0/0")
    )
    error_message = "VALIDATION: In production, SSH access cannot be open to 0.0.0.0/0."
  }
}

variable "name_prefix" {
  description = "Prefix for naming resources"
  type        = string
  default     = "bastion-dev"

  validation {
    condition     = length(var.name_prefix) <= 32
    error_message = "VALIDATION: name_prefix must be <= 32 characters."
  }
}

variable "instance_type" {
  description = "The instance type for the EC2 instances"
  type        = string
  default     = "t3.micro"
  validation {
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "VALIDATION: Instance type must belong to the t3 family."
  }
}

variable "ssm_parameter_name" {
  description = "The name of the SSM parameter that contains the AMI ID for the Bastion Host"
  type        = string
  default     = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

variable "ssh_public_key" {
  description = "The public key for SSH access to EC2 instances"
  type        = string

  validation {
    condition     = can(regex("^ssh-(rsa|ed25519)\\s+[A-Za-z0-9+/=]+", var.ssh_public_key))
    error_message = "VALIDATION: Invalid SSH public key format."
  }
}

variable "user_data" {
  description = "Optional user data script to run on instance launch"
  type        = string
  default     = null
}

### Disk
variable "disk_volume_size" {
  description = "The size of the EBS volume in GB"
  type        = number
  default     = 20

  validation {
    condition     = var.disk_volume_size >= 20 && var.disk_volume_size <= 16384
    error_message = "VALIDATION: disk_volume_size must be between 20 and 16384 GB."
  }
}

variable "disk_volume_type" {
  description = "The type of the EBS volume"
  type        = string
  default     = "gp3"

  validation {
    condition = contains(
      ["gp3", "gp2"],
      var.disk_volume_type
    )
    error_message = "VALIDATION: disk_volume_type must be: gp3, gp2."
  }
}

variable "disk_encrypted" {
  description = "Defines whether the EBS volume will be encrypted."
  type        = bool
  default     = true
}

variable "disk_delete_on_termination" {
  description = "Defines whether the EBS volume will be deleted when the instance is terminated."
  type        = bool
  default     = true
}
