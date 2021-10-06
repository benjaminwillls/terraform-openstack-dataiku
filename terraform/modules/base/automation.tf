variable "automation_count" {
  type    = number
  default = 1
}
# Create floating ip
resource "openstack_networking_floatingip_v2" "automation" {
  count = var.automation_count
  pool  = var.external_network
}
# automation
resource "openstack_networking_secgroup_v2" "automation_secgroup_1" {
  name        = format("%s-%s", var.prefix_name, "automation_secgroup_1")
  description = "automation security group"
  #delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh_worker_automation_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_worker["cidr"]
  security_group_id = openstack_networking_secgroup_v2.automation_secgroup_1.id
}

# Add http to automation
resource "openstack_networking_secgroup_rule_v2" "http_worker_automation_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.automation_secgroup_1.id
}

# automation
output "automation_id" {
  value = openstack_networking_floatingip_v2.automation[*].id
}
output "automation_address" {
  value = openstack_networking_floatingip_v2.automation[*].address
}
output "automation_secgroup_id" {
  value = openstack_networking_secgroup_v2.automation_secgroup_1.id
}
