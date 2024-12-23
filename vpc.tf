# Create a VPC
resource "aws_vpc" "project" {
    cidr_block = var.cidr_block[0]
    tags = {Name = "project"}
}

# Create Internet Gateway 
resource "aws_internet_gateway" "igw" {  
    vpc_id = aws_vpc.project.id
    tags = {Name = "internet gateway"}
}

# Create subnets
resource "aws_subnet" "public" {
    vpc_id     = aws_vpc.project.id
    cidr_block = var.cidr_block[1]
    map_public_ip_on_launch = true
    availability_zone = var.az
    tags = {Name = "public"}
}

resource "aws_subnet" "private" {
    vpc_id     = aws_vpc.project.id
    cidr_block = var.cidr_block[2]
    availability_zone = var.az
    tags = {Name = "private"}
}

resource "aws_subnet" "private2" {
    vpc_id     = aws_vpc.project.id
    cidr_block = var.cidr_block[3]
    availability_zone = "us-east-1b"
    tags = {Name = "private2"}
}

# Create route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.project.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {Name = "public RT"}
}

# Associate route table with subnets
resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

# Security group for web server
resource "aws_security_group" "web" {
    vpc_id = aws_vpc.project.id
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
    tags = {Name = "web sg"}
}

# Security group for db server
resource "aws_security_group" "db" {
    vpc_id = aws_vpc.project.id
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.web.id]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {Name = "db sg"}
}