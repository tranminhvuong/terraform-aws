output "vpc_main" {
  value = {
    vpc_id = module.vpc.vpc_id
  }
}
