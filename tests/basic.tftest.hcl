mock_provider "aws" {
  source          = "./tests/aws"
  override_during = plan
}

run "create_bastion_with_custom_settings" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    subnet_id = "subnet-123456"
    ssh_public_key            = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
    bastion_ssh_ingress_cidrs = ["203.0.113.10/32"]
    environment               = "staging"
    instance_type             = "t3.small"
  }

  assert {
    condition     = aws_instance.bastion.instance_type == "t3.small"
    error_message = "Bastion instance type should reflect the provided input."
  }

  assert {
    condition     = aws_instance.bastion.associate_public_ip_address == true
    error_message = "Bastion instance should have a public IP address."
  }

  assert {
    condition     = aws_instance.bastion.metadata_options[0].http_tokens == "required"
    error_message = "Bastion instance must require IMDSv2 tokens."
  }

  assert {
    condition     = aws_instance.bastion.tags["Environment"] == "staging"
    error_message = "Bastion instance should include the Environment tag from module input."
  }
}
