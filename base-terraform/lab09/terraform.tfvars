region               = "ap-southeast-1"
availability_zones_1 = "ap-southeast-1a"
availability_zones_2 = "ap-southeast-1b"
vpc_cidr             = "10.0.0.0/16"
public_subnet_ips = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]
private_subnet_ips = [
  "10.0.10.0/24",
  "10.0.20.0/24"
]
image_id      = "ami-02159ad7e38d562f2"
instance_type = "t3.micro"
