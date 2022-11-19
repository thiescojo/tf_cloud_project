#---root/variables.tf

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}
variable "specific_ip" {}
variable "key_name" {}
variable "region" {}
variable "access_key" {}
variable "secret_key" {}