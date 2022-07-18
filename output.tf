output "public_ip" {
  value = oci_core_public_ip.free.ip_address
}
