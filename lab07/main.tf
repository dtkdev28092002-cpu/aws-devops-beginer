provider "aws" {
  region = var.region
}

module "networking" {
  source = "./modules/networking"

  region             = var.region
  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnet_ips  = var.public_subnet_ips
  private_subnet_ips = var.private_subnet_ips
}
