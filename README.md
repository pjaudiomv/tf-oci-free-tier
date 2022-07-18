# Creates Free Tier OCI Instance With Apache/PHP/Mysql

* Defaults to ARM based


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_oci"></a> [oci](#requirement\_oci) | ~> 4.84.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudinit"></a> [cloudinit](#provider\_cloudinit) | 2.2.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 2.2.0 |
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.84.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_default_route_table.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_default_route_table) | resource |
| [oci_core_instance.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_public_ip.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_public_ip) | resource |
| [oci_core_security_list.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list) | resource |
| [oci_core_subnet.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn) | resource |
| [cloudinit_config.free](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [http_http.ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [oci_core_images.ubuntu_jammy](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_private_ips.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_private_ips) | data source |
| [oci_core_vnic.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_vnic) | data source |
| [oci_core_vnic_attachments.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_vnic_attachments) | data source |
| [oci_identity_availability_domains.free](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_compartment.default](https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_compartment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_file_profile"></a> [config\_file\_profile](#input\_config\_file\_profile) | The named config file profile. | `string` | `"DEFAULT"` | no |
| <a name="input_region"></a> [region](#input\_region) | The server's desired region. Valid regions at https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm. | `string` | `"us-ashburn-1"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The SSH key used to access the server. | `string` | n/a | yes |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCID of your root tenancy. | `string` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | The vpc cidr block to use. | `string` | `"10.1.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
