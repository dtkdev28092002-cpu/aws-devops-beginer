// define the AWS provider and specify the region
provider "aws" {
  region = "ap-southeast-1"
}

// define resources
// structure of the resource block: resource "resource_type" "resource_name" { ... }

// Init resources keypair
resource "aws_key_pair" "udemy-key" {
  key_name   = "udemy-key"
  public_key = file("./keypair/udemy-key.pub")
}

// Init resources security group
resource "aws_security_group" "udemy-security-group" {
  name        = "udemy-security-group"
  description = "Allow SSH inbound traffic"

  // Inbound rules for the security group
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Outbound rules for the security group
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Init resources ec2 instance
resource "aws_instance" "udemy-instance" {
  ami           = var.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.udemy-key.key_name
  tags = {
    Name = "udemy-instance"
  }
  vpc_security_group_ids = [aws_security_group.udemy-security-group.id]
}
