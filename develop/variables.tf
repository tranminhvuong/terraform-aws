variable "common" {
  type = object({
    project     = string
    environment = string
  })
}

variable "vpc" {
  type = object({
    cidr            = string
    public_subnets  = list(string)
    private_subnets = list(string)
  })
}
