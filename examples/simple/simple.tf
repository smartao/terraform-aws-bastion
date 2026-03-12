provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source = "../../"

  vpc_id                    = "vpc-1234567890abcdef0"
  public_subnet_ids         = ["subnet-1234567890abcdef0"]
  ssh_public_key            = file("/path/to/your/bastion_key.pub")
  bastion_ssh_ingress_cidrs = ["203.0.113.10/32"]
  environment               = "dev"
  name_prefix               = "example-bastion"
}
