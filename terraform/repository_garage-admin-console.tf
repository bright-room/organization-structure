
module "repository_garage_admin_console" {
  source = "./modules/repository"

  name        = "garage-admin-console"
  description = "Admin console for Garage S3-compatible object storage — cluster status, layout, buckets, and key management."
  visibility  = "public"
  topics      = ["garage", "s3", "admin-console", "kotlin", "ktor", "compose-multiplatform", "material3"]

  default_branch_protection = {
    required_status_checks = []
  }

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
