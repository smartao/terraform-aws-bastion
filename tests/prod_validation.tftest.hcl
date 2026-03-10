run "ssh_port_should_be_22" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [ 
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
  }

  assert {
    condition     = aws_security_group_rule.allow_ssh_bastion_from_internet.from_port == 22
    error_message = "SSH ingress port must be 22"
  }
}