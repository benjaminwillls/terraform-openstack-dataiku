variable "postgresql_count" {
  type    = number
  default = 1
}
# Create floating ip
resource "openstack_networking_floatingip_v2" "postgresql" {
  count = var.postgresql_count
  pool  = var.external_network
}
# postgresql
resource "openstack_networking_secgroup_v2" "postgresql_secgroup_1" {
  name        = format("%s-%s", var.prefix_name, "postgresql_secgroup_1")
  description = "postgresql security group"
  #delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh_worker_postgresql_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_worker["cidr"]
  security_group_id = openstack_networking_secgroup_v2.postgresql_secgroup_1.id
}

# Add http to postgresql
resource "openstack_networking_secgroup_rule_v2" "http_worker_postgresql_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 5432
  port_range_max    = 5432
  remote_ip_prefix  = var.network_worker["cidr"]
  # remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.postgresql_secgroup_1.id
}

# postgresql
output "postgresql_id" {
  value = openstack_networking_floatingip_v2.postgresql[*].id
}
output "postgresql_address" {
  value = openstack_networking_floatingip_v2.postgresql[*].address
}
output "postgresql_secgroup_id" {
  value = openstack_networking_secgroup_v2.postgresql_secgroup_1.id
}
