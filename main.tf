resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "terra-vpc"
  }
}
resource "aws_subnet" "subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/25"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-terraform"
  }
}
resource "aws_security_group" "ssh" {
  name = "security-group"
  description = "security-group"
  vpc_id = aws_vpc.vpc.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "terraform route table"
  }
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}
resource "aws_instance" "ec2" {
  ami = "ami-0b0dcb5067f052a63"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet.id
  security_groups = [aws_security_group.ssh.id]
  tags = {
    Name = "terra-ec2"
  }
}
resource "aws_route_table_association" "route-table-association" {
  route_table_id = aws_route_table.route_table.id
  subnet_id = aws_subnet.subnet.id
}
resource "aws_route" "route" {
  route_table_id = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}