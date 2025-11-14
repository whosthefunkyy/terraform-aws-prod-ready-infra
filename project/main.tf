provider "aws" {
 region =    "eu-north-1"
}
/*
module "vpc-default" {
    source = "../modules/network"
}
*/


module "vpctest" {
    source = "git@github.com:whosthefunkyy/terraform-modules1.git//network"
    env = "testing"
    vpc_cidr = "10.10.0.0/16"
    public_subnet_cidr = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnet_cidr = ["10.10.11.0/24", "10.10.22.0/24"]
}
module "security_groups" {
  source = "../modules/security_groups"
  env    = var.env
  vpc_id = module.network.vpc_id
}

module "ec2" {
  source = "../../modules/ec2"
  ami_id             = "ami-0c7d68785ec07306c"
  instance_type      = "t3.micro"
  subnets = module.subnets.private_subnet[0]
  vpc_security_group_ids = [module.security_groups.ec2_sg_id]
  name     = "WebServerInstance"
  user_data = <<EOF
    #!/bin/bash
    yum -y update
    yum -y install httpd
    myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
    echo "<h2>WebServer with IP: $myip</h2>"  >  /var/www/html/index.html
    service httpd start
    chkconfig httpd on
    EOF


}

module "load_balancer" {
  source          = "./modules/load_balancer"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  security_groups = [module.security_groups.alb_sg_id]
  alb_sg_id       = module.security_groups.alb_sg_id
}
module "autoscaling" {
  source           = "./modules/autoscaling"
  private_subnets  = module.vpc.private_subnet_ids
  target_group_arn = module.load_balancer.target_group_arn
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  ec2_sg_id        = module.security_groups.ec2_sg_id
}
module "rds" {
  source = "../modules/rds"

  env                     = var.env
  db_name                 = "appdb"
  db_username             = "admin"
  db_password             = var.db_password

  vpc_id                  = module.vpc.vpc_id
  subnets                 = module.vpc.private_subnet_ids
  vpc_security_group_ids  = [module.security_groups.rds_sg_id]
}


