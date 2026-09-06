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
module "networking" {
  source               = "./modules/networking"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_ips    = var.public_subnet_ips
  private_subnet_ips   = var.private_subnet_ips
  availability_zones_1 = var.availability_zones_1
  availability_zones_2 = var.availability_zones_2
}

module "security" {
  source = "./modules/security"
  region = var.region
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source                 = "./modules/compute"
  region                 = var.region
  image_id               = var.amis[var.region]
  key_name               = aws_key_pair.udemy-key.key_name
  instance_type          = var.instance_type
  subnet_id              = module.networking.public_subnet_ids[0]
  ec2_security_group_ids = [module.security.public_security_group_id]
}
