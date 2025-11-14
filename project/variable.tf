variable "ami_id" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "env" {
  type = string
}
variable "env" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
