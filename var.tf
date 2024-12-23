variable "az" {
    default = "us-east-1a"
}

variable "cidr_block" {
    default = ["10.0.0.0/16", "10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "instance_type" {
    default = "t3.micro"
}

variable "db_instance_type" {
    default = "db.t3.micro"
}

variable "db_username" {    
    default = "root"
}

variable "db_password" {
    default = "#################" # Enter password here
}

variable "db_name" {
    default = "mydb"
}