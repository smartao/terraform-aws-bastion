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