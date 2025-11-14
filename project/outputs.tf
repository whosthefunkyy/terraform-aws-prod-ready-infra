output "load_balancer_dns" {
  value = module.load_balancer.lb_dns_name
}

output "asg_name" {
  value = module.autoscaling.asg_name
}

output "test_public_subnet_ids" {
    value = module.vpc-test.public_subnet_ids
}
output "test_private_subnet_ids" {
    value = module.vpc-test.private_subnet_ids
}