# application stack
variable "postgresql_count" {
  type    = number
  default = 1
}
variable "postgresql_flavor" {
  type    = string
  default = "t1.small"
}
variable "postgresql_data_enable" {
  type = bool
  default = false
}
variable "postgresql_data_size" {
  type = number
  default = 0
}

variable "postgresql_install_script" {
  default = "https://raw.githubusercontent.com/pli01/terraform-openstack-dataiku/main/samples/app/whoami/whoami-docker-deploy.sh"
}
variable "postgresql_variables" {
    type = map
    default = {}
}
variable "postgresql_metric_variables" {
  type = map
  default = {}
}

resource "openstack_blockstorage_volume_v2" "postgresql-data_volume" {
  count = var.postgresql_data_enable ? var.postgresql_count : 0
  name        = format("%s-%s-%s-%s", var.prefix_name, "postgresql", count.index + 1, "data-volume")
  size        = var.postgresql_data_size
  volume_type = var.vol_type
}

module "postgresql" {
  source                   = "./modules/app"
  maxcount                 = var.postgresql_count
  app_name                 = "postgresql"
  prefix_name              = var.prefix_name
  heat_wait_condition_timeout =  var.heat_wait_condition_timeout
  fip                      = module.base.postgresql_id
  network                  = module.base.network_id
  subnet                   = module.base.subnet_id
  source_volid             = module.base.root_volume_id
  security_group           = module.base.postgresql_secgroup_id
  app_data_enable          = var.postgresql_data_enable
  worker_data_volume_id    = openstack_blockstorage_volume_v2.postgresql-data_volume[*].id
  vol_type                 = var.vol_type
  flavor                   = var.postgresql_flavor
  image                    = var.image
  key_name                 = var.key_name
  no_proxy                 = var.no_proxy
  ssh_authorized_keys      = var.ssh_authorized_keys
  internal_http_proxy      = join(" ", formatlist("%s%s:%s", "http://", flatten(module.http_proxy[*].private_ip), "8888"))
  dns_nameservers          = var.dns_nameservers
  dns_domainname           = var.dns_domainname
  syslog_relay             = join("",local.log_public_ip)
  nexus_server             = var.nexus_server
  mirror_docker            = var.mirror_docker
  mirror_docker_key        = var.mirror_docker_key
  docker_version           = var.docker_version
  docker_compose_version   = var.docker_compose_version
  dockerhub_login          = var.dockerhub_login
  dockerhub_token          = var.dockerhub_token
  github_token             = var.github_token
  docker_registry_username = var.docker_registry_username
  docker_registry_token    = var.docker_registry_token
  metric_enable            = var.metric_enable
  metric_install_script    = var.metric_install_script
  metric_variables         = var.postgresql_metric_variables
  app_install_script       = var.postgresql_install_script
  app_variables            = var.postgresql_variables
  depends_on = [
    module.base,
    module.bastion,
    module.http_proxy
  ]
}

locals {
  postgresql_private_ip    = flatten(module.postgresql[*].private_ip)
  postgresql_id            = flatten(module.postgresql[*].id)
  postgresql_public_ip     = flatten(module.base[*].postgresql_address)
}

output "postgresql_id" {
  value = local.postgresql_id
}
output "postgresql_private_ip" {
  value = local.postgresql_private_ip
}
output "postgresql_public_ip" {
  value = local.postgresql_public_ip
}
