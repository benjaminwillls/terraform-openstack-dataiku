# output
locals {
  bastion_private_ip    = flatten(module.bastion[*].private_ip)
  bastion_id            = flatten(module.bastion[*].id)
  http_proxy_private_ip = flatten(module.http_proxy[*].private_ip)
  http_proxy_id         = flatten(module.http_proxy[*].id)
  log_private_ip        = flatten(module.log[*].private_ip)
  log_id                = flatten(module.log[*].id)
  log_public_ip         = flatten(module.base[*].log_address)
  lb_private_ip         = flatten(module.lb[*].private_ip)
  lb_id                 = flatten(module.lb[*].id)
  lb_public_ip          = flatten(module.base[*].lb_address)
  dss_private_ip        = flatten(module.dss[*].private_ip)
  dss_id                = flatten(module.dss[*].id)
  dss_public_ip         = flatten(module.base[*].dss_address)
}

output "bastion_id" {
  value = local.bastion_id
}
output "bastion_private_ip" {
  value = local.bastion_private_ip
}
output "bastion_public_ip" {
  value = module.base.bastion_address
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

output "dss_id" {
  value = local.dss_id
}
output "dss_private_ip" {
  value = local.dss_private_ip
}
output "dss_public_ip" {
  value = local.dss_public_ip
}


