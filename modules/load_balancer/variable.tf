variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "target_group_port" {
  type    = number
  default = 80
}
variable "public_subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "alb_sg_id" {
  type = string
}

variable "vpc_id" {
  type = string
}