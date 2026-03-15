mock_provider "aws" {
  source          = "./tests/aws"
  override_during = plan
}

run "ssh_rule_should_use_port_22_and_input_cidrs" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
    bastion_ssh_ingress_cidrs = [
      "203.0.113.10/32"
    ]
  }

  assert {
    condition     = aws_security_group_rule.allow_ssh_bastion_from_internet.from_port == 22
    error_message = "SSH ingress port must be 22."
  }

  assert {
    condition     = aws_security_group_rule.allow_ssh_bastion_from_internet.to_port == 22
    error_message = "SSH ingress destination port must be 22."
  }

  assert {
    condition     = sort(tolist(aws_security_group_rule.allow_ssh_bastion_from_internet.cidr_blocks)) == sort(["203.0.113.10/32"])
    error_message = "SSH ingress CIDRs should reflect the provided input."
  }
}
