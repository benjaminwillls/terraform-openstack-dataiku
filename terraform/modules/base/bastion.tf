# Create floating ip
resource "openstack_networking_floatingip_v2" "bastion" {
  pool = var.external_network
}

# bastion
resource "openstack_networking_secgroup_v2" "bastion_secgroup_1" {
  name        = format("%s-%s", var.prefix_name, "bastion_secgroup_1")
  description = "Bastion security group"
  #delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh_bastion_bastion_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.ssh_access_cidr
  security_group_id = openstack_networking_secgroup_v2.bastion_secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh_worker_bastion_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_worker["cidr"]
  security_group_id = openstack_networking_secgroup_v2.bastion_secgroup_1.id
}

# bastion
output "bastion_id" {
  value = openstack_networking_floatingip_v2.bastion.id
}
output "bastion_address" {
  value = openstack_networking_floatingip_v2.bastion.address
}
output "bastion_secgroup_id" {
  value = openstack_networking_secgroup_v2.bastion_secgroup_1.id
}
