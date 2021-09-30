variable "dss_count" {
  type    = number
  default = 1
}
# Create floating ip
resource "openstack_networking_floatingip_v2" "dss" {
  count = var.dss_count
  pool  = var.external_network
}
# dss
resource "openstack_networking_secgroup_v2" "dss_secgroup_1" {
  name        = format("%s-%s", var.prefix_name, "dss_secgroup_1")
  description = "dss security group"
  #delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh_worker_dss_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_worker["cidr"]
  security_group_id = openstack_networking_secgroup_v2.dss_secgroup_1.id
}

# Add http to dss
resource "openstack_networking_secgroup_rule_v2" "http_worker_dss_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.dss_secgroup_1.id
}

# dss
output "dss_id" {
  value = openstack_networking_floatingip_v2.dss[*].id
}
output "dss_address" {
  value = openstack_networking_floatingip_v2.dss[*].address
}
output "dss_secgroup_id" {
  value = openstack_networking_secgroup_v2.dss_secgroup_1.id
}
