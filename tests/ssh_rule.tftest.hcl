run "prod_must_not_allow_open_ssh" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"

    environment = "prod"
    bastion_ssh_ingress_cidrs = [
      "0.0.0.0/0"
    ]
  }

  expect_failures = [
    var.bastion_ssh_ingress_cidrs
  ]
}