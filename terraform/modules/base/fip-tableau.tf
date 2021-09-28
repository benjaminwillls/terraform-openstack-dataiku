# Create floating ip
resource "openstack_networking_floatingip_v2" "tableau" {
  count = var.tableau_count
  pool  = var.external_network
}
