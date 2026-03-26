# Simple Bastion Example

This example shows a minimal usage of the bastion module for an existing AWS VPC.

## Before You Run

Replace the placeholder values in `simple.tf`:

- `vpc_id`
- `subnet_id`
- `ssh_public_key`

You also need:

- AWS credentials configured locally
- A public subnet in the target VPC
- A valid SSH public key

Example key generation:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/bastion_key
```

Then update the module input to use the generated public key, for example:

```hcl
ssh_public_key = file("${path.module}/bastion_key.pub")
```

## Run

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- The module creates the bastion in the provided `subnet_id`
- `bastion_ssh_ingress_cidrs` is required and must be set explicitly
- For real environments, restrict SSH access to trusted CIDRs such as your public IP with `/32`
