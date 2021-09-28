# tableau
output "tableau_id" {
  value = openstack_networking_floatingip_v2.tableau[*].id
}
output "tableau_address" {
  value = openstack_networking_floatingip_v2.tableau[*].address
}
output "tableau_secgroup_id" {
  value = openstack_networking_secgroup_v2.tableau_secgroup_1.id
}
