provider "aws" {
  region = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  shared_credentials_file = "/root/.aws/credentials"
} 

resource "aws_vpc" "bakery_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "bakery_igw" {
  vpc_id = aws_vpc.bakery_vpc.id
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.bakery_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.bakery_igw.id
}

resource "aws_subnet" "bakery_subnet" {
  vpc_id                  = aws_vpc.bakery_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}


resource "aws_instance" "terraform-example" {
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type = "ssh"
    user = "centos"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }

  instance_type = "t2.micro"

  ami = var.ami[var.region]

  vpc_security_group_ids = [aws_security_group.terraform-example.id]

  subnet_id = aws_subnet.bakery_subnet.id

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }
}

resource "aws_security_group" "terraform-example" {
  name        = "terraform_example"
  description = "Used in the terraform"
  vpc_id      = aws_vpc.bakery_vpc.id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "terraform-example" {
  name = "terraform-example-elb"

  subnets         = [aws_subnet.bakery_subnet.id]
  instances       = [aws_instance.terraform-example.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

