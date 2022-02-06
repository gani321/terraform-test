provider "aws" {
  region     = "region"
  access_key = "access_key"
  secret_key = "secret_key"
}

provider "aws" {
  region     = "ap-south-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc"
  }
}
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "pvtsubnet"
  }
}
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "pubsubnet"
  }
}
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myigw"
  }
}
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "myrt"
  }
}
resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.myrt.id
}
resource "aws_security_group" "allow_sshhttp" {
  name        = "allow_sshhttp"
  description = "Allow sshhttp inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "ssh from everywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "http from everywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sshhttp"
  }
}
resource "aws_instance" "tf" {
  ami           = " ami  " # ap-west-1
  instance_type = "t2.micro"
  key_name               = "eee"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.allow_sshhttp.id]
  subnet_id              = aws_subnet.public_subnet.id
  #delete_on_termination = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Name        = "tf-instance"
  }
}
