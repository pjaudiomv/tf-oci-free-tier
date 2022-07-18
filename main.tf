provider "oci" {
  region              = var.region
  config_file_profile = var.config_file_profile
}

terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 4.84.0"
    }
  }
}
