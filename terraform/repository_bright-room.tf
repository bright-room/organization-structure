
module "repository_bright_room" {
  source = "./modules/repository"

  name        = "bright-room"
  description = "Homepage for the bright-room organization."
  visibility  = "public"

  topics = [
    "kotlin",
    "kotlin-multiplatform",
    "compose-multiplatform",
    "material3",
    "webassembly",
    "github-pages",
    "i18n",
    "dark-mode",
    "homepage",
  ]

  default_branch_protection = {
    required_status_checks = [
      { context = "check" }
    ]
  }

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]
}
