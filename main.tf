resource "aws_security_group" "sg_bastion" {
  name        = "${var.name_prefix}-bastion-sg"
  description = "Allow SSH access to Bastion Host"
  vpc_id      = var.vpc_id

  tags = merge(
    {
      Name        = "${var.name_prefix}-bastion-sg"
      Environment = var.environment
    },
    var.tags
  )
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "allow_bastion_to_internet" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bastion.id
  description       = "Allow all outbound traffic from Bastion Host"
}

resource "aws_security_group_rule" "allow_ssh_bastion_from_internet" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.bastion_ssh_ingress_cidrs
  security_group_id = aws_security_group.sg_bastion.id
  description       = "Allow SSH from trusted IPs"
}



data "aws_ssm_parameter" "ubuntu" {
  name = var.ssm_parameter_name
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.name_prefix}-bastion-key"
  public_key = var.ssh_public_key
}


# Bastion Host
resource "aws_instance" "bastion" {
  ami                         = data.aws_ssm_parameter.ubuntu.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id # Place Bastion in the provided public subnet
  vpc_security_group_ids      = [aws_security_group.sg_bastion.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name

  user_data = var.user_data

  root_block_device {
    volume_size           = var.disk_volume_size
    volume_type           = var.disk_volume_type
    encrypted             = var.disk_encrypted
    delete_on_termination = var.disk_delete_on_termination
    tags = merge(
      {
        Name        = "${var.name_prefix}-bastion-root"
        Environment = var.environment
      },
      var.tags
    )
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    {
      Name        = "${var.name_prefix}-BastionHost"
      Environment = var.environment
    },
    var.tags
  )
}
