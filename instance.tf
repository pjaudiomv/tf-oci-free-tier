resource "oci_core_instance" "dijon" {
  availability_domain = oci_core_subnet.dijon.availability_domain
  compartment_id      = data.oci_identity_compartment.default.id
  display_name        = "dijon-${terraform.workspace}"
  shape               = "VM.Standard.A1.Flex" # VM.Standard.E2.1.Micro If Using AMD

  create_vnic_details {
    assign_public_ip = false
    display_name     = "eth01"
    hostname_label   = "dijon"
    subnet_id        = oci_core_subnet.dijon.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.cloudinit_config.dijon.rendered
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_jammy_arm.images.0.id
    # data.oci_core_images.ubuntu_jammy.images.0.id
    # If Using AMD
  }

  #  Remove this block If Using AMD
  shape_config {
    ocpus         = 2 # Can be up to 4 for dijon tier
    memory_in_gbs = 8 # Can be up to 24 for dijon tier
  }
}

resource "oci_core_public_ip" "dijon" {
  compartment_id = data.oci_identity_compartment.default.id
  display_name   = "dijon-${terraform.workspace}"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.dijon.private_ips[0]["id"]
}

data "oci_core_vnic_attachments" "dijon" {
  compartment_id      = data.oci_identity_compartment.default.id
  availability_domain = local.availability_domain
  instance_id         = oci_core_instance.dijon.id
}

data "oci_core_vnic" "dijon" {
  vnic_id = data.oci_core_vnic_attachments.dijon.vnic_attachments[0]["vnic_id"]
}

data "oci_core_private_ips" "dijon" {
  vnic_id = data.oci_core_vnic.dijon.id
}

data "oci_identity_compartment" "default" {
  id = var.tenancy_ocid
}

data "oci_identity_availability_domains" "dijon" {
  compartment_id = data.oci_identity_compartment.default.id
}

resource "oci_core_vcn" "dijon" {
  dns_label      = "dijon"
  cidr_block     = var.vpc_cidr_block
  compartment_id = data.oci_identity_compartment.default.id
  display_name   = "dijon-${terraform.workspace}"
}

resource "oci_core_internet_gateway" "dijon" {
  compartment_id = data.oci_identity_compartment.default.id
  vcn_id         = oci_core_vcn.dijon.id
  display_name   = "dijon-${terraform.workspace}"
  enabled        = "true"
}

resource "oci_core_default_route_table" "dijon" {
  manage_default_resource_id = oci_core_vcn.dijon.default_route_table_id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.dijon.id
  }
}

resource "oci_core_security_list" "dijon" {
  compartment_id = data.oci_identity_compartment.default.id
  vcn_id         = oci_core_vcn.dijon.id
  display_name   = "dijon-${terraform.workspace}"
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = "0.0.0.0/0"

    #    protocol = "6"
    #    source   = local.myip
    #
    #    tcp_options {
    #      min = 22
    #      max = 22
    #    }
  }
}

resource "oci_core_subnet" "dijon" {
  availability_domain        = local.availability_domain
  cidr_block                 = cidrsubnet(var.vpc_cidr_block, 8, 0)
  display_name               = "dijon-${terraform.workspace}"
  prohibit_public_ip_on_vnic = false
  dns_label                  = "dijon"
  compartment_id             = data.oci_identity_compartment.default.id
  vcn_id                     = oci_core_vcn.dijon.id
  route_table_id             = oci_core_default_route_table.dijon.id
  security_list_ids          = [oci_core_security_list.dijon.id]
  dhcp_options_id            = oci_core_vcn.dijon.default_dhcp_options_id
}

data "oci_core_images" "ubuntu_jammy" {
  compartment_id   = data.oci_identity_compartment.default.id
  operating_system = "Canonical Ubuntu"
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-22.04-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "oci_core_images" "ubuntu_jammy_arm" {
  compartment_id   = data.oci_identity_compartment.default.id
  operating_system = "Canonical Ubuntu"
  filter {
    name   = "display_name"
    values = ["^Canonical-Ubuntu-22.04-aarch64-([\\.0-9-]+)$"]
    regex  = true
  }
}

data "cloudinit_config" "dijon" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
#cloud-config

package_update: true
package_upgrade: true
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - python3-certbot-apache
  - htop
  - jq
  - haveged
  - docker.io
  - docker-compose
EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<BOF
#!/bin/bash
mkdir -p /opt/dijon/compose
mkdir -p /opt/dijon/mysql
mkdir -p /opt/dijon/letsencrypt
BOF
  }
}

data "http" "ip" {
  url = "https://ifconfig.me/all.json"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  myip                = "${jsondecode(data.http.ip.body).ip_addr}/32"
  availability_domain = [for i in data.oci_identity_availability_domains.dijon.availability_domains : i if length(regexall("US-ASHBURN-AD-3", i.name)) > 0][0].name
}
