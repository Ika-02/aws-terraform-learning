# AMI data source for Amazon Linux 2
data "aws_ami" "amazon-linux-2" {
    most_recent = true
    owners = ["amazon"] 
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm*"]
    }
}

# EC2 instance for web server
resource "aws_instance" "web" {
    ami           = "${data.aws_ami.amazon-linux-2.id}"
    instance_type = var.instance_type
    subnet_id     = aws_subnet.public.id
    security_groups = [aws_security_group.web.id]
    tags = {Name = "web"}
    user_data = <<-EOF
                #!/bin/bash -xe
                yum update -y && yum install httpd -y
                systemctl enable --now httpd
                echo "<h1>Welcome to Terraform</h1>" > /var/www/html/index.html
                EOF
}

resource "aws_db_subnet_group" "db_subnet_group" {
    name       = "db_subnet_group"
    subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]
    tags = {Name = "DB subnet group"}
}

# RDS instance for db server
resource "aws_db_instance" "db" {
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    allocated_storage    = 20
    storage_type         = "gp3"
    engine               = "mysql"
    engine_version       = "5.7"
    instance_class       = var.db_instance_type
    db_name              = var.db_name
    username             = var.db_username
    password             = var.db_password
    parameter_group_name = "default.mysql5.7"
    publicly_accessible  = false
    skip_final_snapshot  = true
    vpc_security_group_ids = [aws_security_group.db.id]
    tags = {Name = "db"}
}