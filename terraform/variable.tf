variable "region" {
  type    = string
  default = "us-east-1"
}
variable "ingress_ports" {
  type    = list(number)
  default = [3000, 80]
}
variable "container_port" {
  type    = number
  default = 3000
}
