#variables.tf

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "GS_instance"
}

variable "ubuntu_ami" {
  description = "ubuntu ami"
  type        = string
  default     = "ami-04ff9e9b51c1f62ca"
}
variable "linux_ami" {
  description = "linux ami"
  type        = string
  default     = "ami-04f7efe62f419d9f5"
}

variable "ec2" {
  description = "The attribute of EC2 information"
  type = object({
    name              = string
    os_type           = string
    instance_type     = string
    volume_size       = number
    volume_type       = string
    availability_zone = string
  })
  default = {
    instance_type     = "t2.micro"
    name              = "ppshein"
    os_type           = "linux"
    volume_size       = 20
    volume_type       = "gp3"
    availability_zone = "eu-west-1"    
  }
}

variable "security_groups" {
  description = "The attribute of security_groups information"
  type = list(object({
    name        = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
        {
            from_port   = 22
            name        = "Office Wifi CIDR Range"
            protocol    = "tcp"
            to_port     = 22
            cidr_blocks = ["0.0.0.0/0"] # you can replace with your office wifi outbount IP range
        }, 
        {
            from_port   = 80
            name        = "Web services"
            protocol    = "tcp"
            to_port     = 80
            cidr_blocks = ["0.0.0.0/0"]
        },
        {
            from_port   = 8086
            name        = "InfluxDB"
            protocol    = "tcp"
            to_port     = 8086
            cidr_blocks = ["0.0.0.0/0"]
        }]
}