run "name_prefix_must_be_short_enough" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
    name_prefix    = "this-prefix-is-definitely-longer-than-thirty-two-characters"
  }

  expect_failures = [
    var.name_prefix
  ]
}

run "ssh_public_key_must_be_valid" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key = "invalid-key"
  }

  expect_failures = [
    var.ssh_public_key
  ]
}

run "disk_volume_size_must_be_in_range" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
    disk_volume_size = 10
  }

  expect_failures = [
    var.disk_volume_size
  ]
}

run "disk_volume_type_must_be_supported" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [
      "subnet-123456"
    ]
    ssh_public_key  = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
    disk_volume_type = "io2"
  }

  expect_failures = [
    var.disk_volume_type
  ]
}
