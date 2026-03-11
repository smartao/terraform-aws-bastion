provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source  = "smartao/bastion/aws"
  version = "0.2.1"

  vpc_id            = "vpc-123456"
  public_subnet_ids = ["subnet-123456"]
  ssh_public_key    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
}
