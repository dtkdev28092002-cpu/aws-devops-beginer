// define the AWS provider and specify the region
provider "aws" {
  region = var.region
}

// define resources
// structure of the resource block: resource "resource_type" "resource_name" { ... }

// Init resources keypair
resource "aws_key_pair" "udemy-key" {
  key_name   = "udemy-key"
  public_key = file(var.keypair_path)
}

// Init resources security group
module "security" {
  source = "./modules/security"
  region = var.region
}

module "compute" {
  source                 = "./modules/compute"
  region                 = var.region
  image_id               = var.amis[var.region]
  key_name               = aws_key_pair.udemy-key.key_name
  instance_type          = var.instance_type
  ec2_security_group_ids = [module.security.public_security_group_id]
}
