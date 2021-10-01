# output
locals {
  http_proxy_private_ip = flatten(module.http_proxy[*].private_ip)
  http_proxy_id         = flatten(module.http_proxy[*].id)
  log_private_ip        = flatten(module.log[*].private_ip)
  log_id                = flatten(module.log[*].id)
  log_public_ip         = flatten(module.base[*].log_address)
  lb_private_ip         = flatten(module.lb[*].private_ip)
  lb_id                 = flatten(module.lb[*].id)
  lb_public_ip          = flatten(module.base[*].lb_address)
}

output "http_proxy_id" {
  value = local.http_proxy_id
}
output "http_proxy_private_ip" {
  value = local.http_proxy_private_ip
}
output "http_proxy_public_ip" {
  value = module.base.http_proxy_address
}

output "log_id" {
  value = local.log_id
}
output "log_private_ip" {
  value = local.log_private_ip
}
output "log_public_ip" {
  value = local.log_public_ip
}

output "lb_id" {
  value = local.lb_id
}
output "lb_private_ip" {
  value = local.lb_private_ip
}
output "lb_public_ip" {
  value = local.lb_public_ip
}
