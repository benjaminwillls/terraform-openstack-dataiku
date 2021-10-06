# application stack
variable "automation_count" {
  type    = number
  default = 1
}
variable "automation_flavor" {
  type    = string
  default = "t1.small"
}
variable "automation_data_enable" {
  type = bool
  default = false
}
variable "automation_data_size" {
  type = number
  default = 0
}

variable "automation_install_script" {
  default = "https://raw.githubusercontent.com/pli01/terraform-openstack-dataiku/main/samples/app/whoami/whoami-docker-deploy.sh"
}
variable "automation_variables" {
    type = map
    default = {}
}
variable "automation_metric_variables" {
  type = map
  default = {}
}

resource "openstack_blockstorage_volume_v2" "automation-data_volume" {
  count = var.automation_data_enable ? var.automation_count : 0
  name        = format("%s-%s-%s-%s", var.prefix_name, "automation", count.index + 1, "data-volume")
  size        = var.automation_data_size
  volume_type = var.vol_type
}

module "automation" {
  source                   = "./modules/app"
  maxcount                 = var.automation_count
  app_name                 = "automation"
  prefix_name              = var.prefix_name
  heat_wait_condition_timeout =  var.heat_wait_condition_timeout
  fip                      = module.base.automation_id
  network                  = module.base.network_id
  subnet                   = module.base.subnet_id
  source_volid             = module.base.root_volume_id
  security_group           = module.base.automation_secgroup_id
  app_data_enable          = var.automation_data_enable
  worker_data_volume_id    = openstack_blockstorage_volume_v2.automation-data_volume[*].id
  vol_type                 = var.vol_type
  flavor                   = var.automation_flavor
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
  metric_variables         = var.automation_metric_variables
  app_install_script       = var.automation_install_script
  app_variables            = var.automation_variables
  depends_on = [
    module.base,
    module.bastion,
    module.http_proxy
  ]
}

locals {
  automation_private_ip        = flatten(module.automation[*].private_ip)
  automation_id                = flatten(module.automation[*].id)
  automation_public_ip         = flatten(module.base[*].automation_address)
}

output "automation_id" {
  value = local.automation_id
}
output "automation_private_ip" {
  value = local.automation_private_ip
}
output "automation_public_ip" {
  value = local.automation_public_ip
}
