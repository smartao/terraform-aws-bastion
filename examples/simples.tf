provider "aws" {
  region = "us-east-1"
}

module "bastion" {
  source  = "smartao/bastion/aws"
  version = "0.2.0"

  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  ssh_public_key    = file(ssh_public_key_path)

}