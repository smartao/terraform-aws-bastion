run "disk_should_be_encrypted_by_default" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [ 
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
  }

  assert {
    condition     = aws_instance.bastion.root_block_device[0].encrypted == true
    error_message = "Root volume must be encrypted"
  }
}