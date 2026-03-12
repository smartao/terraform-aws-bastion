run "instance_type_must_be_t3" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"

    instance_type = "m5.large"
  }

  expect_failures = [
    var.instance_type
  ]

}

run "instance_type_allows_other_t3_sizes" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"

    instance_type = "t3.small"
  }

  assert {
    condition     = aws_instance.bastion.instance_type == "t3.small"
    error_message = "Module should accept instance types from the t3 family."
  }
}
