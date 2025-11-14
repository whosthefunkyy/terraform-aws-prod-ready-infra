provider "aws" {
 region =    "eu-north-1"
}
/*
module "vpc-default" {
    source = "../modules/network"
}
*/
module "vpc-dev" {
    
    source = "git@github.com:whosthefunkyy/terraform-modules1.git//network"
    env = "development"
    vpc_cidr = "10.100.0.0/16"
    public_subnet_cidr = ["10.100.1.0/24", "10.100.2.0/24"]
    private_subnet_cidr = []
}
module "vpc-prod" {
   
    source = "git@github.com:whosthefunkyy/terraform-modules1.git//network"
    env = "production"
    vpc_cidr = "10.10.0.0/16"
    public_subnet_cidr = ["10.10.1.0/24", "10.10.2.0/24","10.10.3.0/24"]
    private_subnet_cidr = ["10.10.11.0/24", "10.10.22.0/24", "10.10.33.0/24"]
}

module "vpc-test" {
    source = "git@github.com:whosthefunkyy/terraform-modules1.git//network"
    env = "testing"
    vpc_cidr = "10.10.0.0/16"
    public_subnet_cidr = ["10.10.1.0/24", "10.10.2.0/24"]
    private_subnet_cidr = ["10.10.11.0/24", "10.10.22.0/24"]
}
#===================================================================================================
output "prod_public_subnet_ids" {
    value = module.vpc-prod.public_subnet_ids
}
output "prod_private_subnet_ids" {
    value = module.vpc-prod.private_subnet_ids
}