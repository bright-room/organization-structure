
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

  pages = {
    build_type     = "workflow"
    cname          = "bright-room.net"
    https_enforced = true
  }

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

# Import the existing Pages site that was previously managed via the UI.
# After this PR is applied successfully, the import block can be removed.
import {
  to = module.repository_bright_room.github_repository_pages.this[0]
  id = "bright-room"
}
