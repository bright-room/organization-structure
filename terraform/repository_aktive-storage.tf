module "repository_aktive_storage" {
  source = "./modules/repository"

  name        = "aktive-storage"
  description = "Framework-agnostic file attachment toolkit for the JVM — a Kotlin core with pluggable storage, ORM, and image-variant adapters."
  visibility  = "public"
  topics      = ["kotlin", "jvm", "library", "coroutines", "file-attachment", "object-storage"]

  default_branch_protection = {
    required_status_checks = []
  }

  organization_secrets = [
    local.organization_secrets.pgp_signing_key,
    local.organization_secrets.pgp_signing_key_passphrase,
    local.organization_secrets.sonatype_central_password,
    local.organization_secrets.sonatype_central_username,
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
