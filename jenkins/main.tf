terraform {
  backend "s3" {
    bucket         = "khangdt-terraform"
    key            = "terraform"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state"
  }
}
provider "aws" {
  region = var.region_name
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

module "security_group" {
  source = "./modules/security"
  myIp   = var.myIp
}

module "compute" {
  source             = "./modules/compute"
  image_id           = var.image_id
  instance_type      = var.instance_type
  key_name           = aws_key_pair.jenkins_key.key_name
  volume_size        = var.volume_size
  security_group_ids = [module.security_group.security_group_jenkins_id]
}
