# Fournisseur AWS
provider "aws" {
  region = "eu-west-3"  # Région Paris
}

# Création du VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MainVPC"
  }
}

# Création du sous-réseau public
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "eu-west-3a"
  tags = {
    Name = "PublicSubnet"
  }
}

# Passerelle Internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "InternetGateway"
  }
}

# Table de routage pour le sous-réseau public
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "PublicRouteTable"
  }
}

# Association de la table de routage avec le sous-réseau public
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Groupe de sécurité pour l'instance EC2
resource "aws_security_group" "sg" {
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "WebServerSG"
  }
}

# Instance EC2 avec Nginx
resource "aws_instance" "web" {
  ami                    = "ami-0e41fc02dc8fca79b"  # AMI valide (ex. Amazon Linux 2)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name               = "clessh"  # Remplacez par votre clé SSH
  vpc_security_group_ids = [aws_security_group.sg.id]

  tags = {
    Name = "NginxWebServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install nginx1 -y
              systemctl start nginx
              EOF
}

# Sortie pour obtenir l'adresse IP publique
output "instance_public_ip" {
  value = aws_instance.web.public_ip
  description = "Adresse IP publique de l'instance EC2"
}
