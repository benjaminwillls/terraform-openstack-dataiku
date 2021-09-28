# tableau
resource "openstack_networking_secgroup_v2" "tableau_secgroup_1" {
  name        = format("%s-%s", var.prefix_name, "tableau_secgroup_1")
  description = "tableau security group"
  #delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "ssh_worker_tableau_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.network_worker["cidr"]
  security_group_id = openstack_networking_secgroup_v2.tableau_secgroup_1.id
}

# Add http to tableau
resource "openstack_networking_secgroup_rule_v2" "http_worker_tableau_secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.tableau_secgroup_1.id
}

