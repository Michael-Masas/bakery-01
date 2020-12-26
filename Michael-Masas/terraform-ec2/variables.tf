variable "region" {
  type    = string
  default = "us-east-1"
}


variable "ami" {
  type = map
  default = {
    us-east-2 = "ami-00f8e2c955f7ffa9b"
    us-east-1 = "ami-00e87074e52e6c9f9"
    us-west-1 = "ami-08d2d8b00f270d03b"
    us-west-2 = "ami-0686851c4e7b1a8e1"
  }
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}
