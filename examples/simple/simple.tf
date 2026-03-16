provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source = "../../"

  vpc_id                    = "vpc-1234567890abcdef0"
  subnet_id                 = "subnet-1234567890abcdef0"
  ssh_public_key            = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey" # Replacing file() for example clarity or keeping it simple

  bastion_ssh_ingress_cidrs = ["203.0.113.10/32"]
  environment               = "dev"
  name_prefix               = "example-bastion"

  tags = {
    Project   = "Security"
    ManagedBy = "Terraform"
  }
}
