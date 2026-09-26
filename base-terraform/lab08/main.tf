provider "aws" {
  region = var.region
}

resource "aws_key_pair" "key" {
  key_name   = "my-keypair"
  public_key = file(var.keypair_path)
}

module "network" {
  source             = "./modules/network"
  vpc_name           = var.vpc_name
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnet_ips  = var.public_subnet_ips
  private_subnet_ips = var.private_subnet_ips
}

module "security" {
  source         = "./modules/security"
  vpc_id         = module.network.vpc_id
  workstation_ip = var.workstation_ip

  depends_on = [module.network]
}

module "bastion" {
  source            = "./modules/bastion"
  ami               = var.bastion_ami
  instance_type     = var.bastion_instance_type
  subnet_id         = module.network.public_subnets[0]
  key_name          = aws_key_pair.key.key_name
  security_group_id = module.security.bastion_sg_id

  depends_on = [
    module.security,
    module.network
  ]
}

module "storage" {
  source            = "./modules/storage"
  ami               = var.db_ami
  instance_type     = var.db_instance_type
  subnet_id         = module.network.private_subnets[0]
  key_name          = aws_key_pair.key.key_name
  security_group_id = module.security.mongo_sg_id

  depends_on = [
    module.security,
    module.network
  ]
}

module "application" {
  source          = "./modules/application"
  ami             = var.app_ami
  instance_type   = var.app_instance_type
  key_name        = aws_key_pair.key.key_name
  vpc_id          = module.network.vpc_id
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.private_subnets
  webserver_sg_id = module.security.application_sg_id
  alb_sg_id       = module.security.alb_sg_id
  mongodb_ip      = module.storage.private_ip

  depends_on = [
    module.storage,
    module.security,
    module.network
  ]
}
