// define the AWS provider and specify the region
provider "aws" {
  region = var.region
}

// define resources
// structure of the resource block: resource "resource_type" "resource_name" { ... }

// Init resources security group
module "networking" {
  source               = "../modules/networking"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_ips    = var.public_subnet_ips
  private_subnet_ips   = var.private_subnet_ips
  availability_zones_1 = var.availability_zones_1
  availability_zones_2 = var.availability_zones_2
}
