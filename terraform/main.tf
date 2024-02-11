terraform {
  required_version = ">= 1.5.0"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.43.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 4.12.0"
    }
  }

  backend "s3" {
    bucket = "terraform-state"
    key    = "orbituary/terraform.tfstate"
    region = "us-east-1"

    skip_credentials_validation = true
    skip_region_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_s3_checksum = true
  }
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

