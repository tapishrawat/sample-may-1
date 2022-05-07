variable "count_number" {
  default = 1
}
variable "instance_type" {
  default = "t2.large"
}
variable "volume_size" {
  default = 20
}
variable "Name" {
  default = "kul"
}
variable "Client" {
  default = "thinknyx"
}
locals {
  Name = "${var.Name}_${var.Client}"
}
