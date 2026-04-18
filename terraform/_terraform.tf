terraform {
  required_providers {
    github = {
      version = "6.11.1"
      source  = "integrations/github"
    }
  }

  backend "s3" {
    bucket = "github-organization-tfstates"
    key    = "organization-structure/terraform.tfstate"

    endpoints = {
      s3 = "https://8416648cab62a7df5d564f8536d84b9a.r2.cloudflarestorage.com"
    }
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    use_lockfile                = true
  }
}

provider "github" {
  owner = "bright-room"
}
