region   = "ap-southeast-1"
vpc_name = "udemy-vpc"
availability_zones = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]
vpc_cidr = "10.0.0.0/16"
public_subnet_ips = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_subnet_ips = [
  "10.0.10.0/24",
  "10.0.20.0/24"
]
workstation_ip        = "162.120.184.63/32"
bastion_instance_type = "t3.micro"
bastion_ami           = "ami-0fa377108253bf620" #Ubuntu 22.04
app_instance_type     = "t3.micro"
app_ami               = "ami-0fea1654c99ae8095" #Ubuntu 20.04
db_instance_type      = "t3.micro"
db_ami                = "ami-0fa377108253bf620" #Ubuntu 22.04
keypair_path          = "./keypair/udemy-key.pub"
