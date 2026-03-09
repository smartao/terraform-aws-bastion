run "create_bastion" {

  command = plan

  variables {
    vpc_id = "vpc-123456"
    public_subnet_ids = [ 
      "subnet-123456"
    ]
    ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAITestKey"
  }


  assert {
    condition     = aws_instance.bastion.instance_type == "t3.micro"
    error_message = "Bastion instance type should be t3.micro"
  }
}