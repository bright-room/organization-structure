terraform {
  required_providers {
    github = {
      version = "6.11.1"
      source  = "integrations/github"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "bright-room"
    workspaces {
      name = "organization-structure"
    }
  }
}

provider "github" {
  owner = "bright-room"
}
