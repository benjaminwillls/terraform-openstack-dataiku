# bastion
variable "bastion_count" {
  type    = number
  default = 1
}
variable "bastion_flavor" {
  type    = string
  default = "t1.small"
}
variable "bastion_data_enable" {
  type = bool
  default = false
}
variable "bastion_data_size" {
  type = number
  default = 0
}

resource "openstack_blockstorage_volume_v2" "bastion-data_volume" {
  count = var.bastion_data_enable ? var.bastion_count : 0
  name        = format("%s-%s-%s-%s", var.prefix_name, "bastion", count.index + 1, "data-volume")
  size        = var.bastion_data_size
  volume_type = var.vol_type
}

module "bastion" {
  source              = "./modules/bastion"
  maxcount            = var.bastion_count
  prefix_name         = var.prefix_name
  heat_wait_condition_timeout =  var.heat_wait_condition_timeout
  fip                 = module.base.bastion_id
  network             = module.base.network_id
  subnet              = module.base.subnet_id
  source_volid        = module.base.root_volume_id
  security_group      = module.base.bastion_secgroup_id
  bastion_data_enable = var.bastion_data_enable
  worker_data_volume_id = openstack_blockstorage_volume_v2.bastion-data_volume[*].id
  vol_type            = var.vol_type
  flavor              = var.bastion_flavor
  image               = var.image
  key_name            = var.key_name
  no_proxy            = var.no_proxy
  ssh_authorized_keys = var.ssh_authorized_keys
  syslog_relay             = join("",local.log_public_ip)
  depends_on = [
    module.base
  ]
}

locals {
  bastion_private_ip    = flatten(module.bastion[*].private_ip)
  bastion_id            = flatten(module.bastion[*].id)
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


