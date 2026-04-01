
module "repository_bright_room_github_io" {
  source = "./modules/repository"

  name         = "bright-room.github.io"
  description  = "Homepage for the bright-room organization."
  homepage_url = "https://bright-room.github.io"
  visibility   = "public"

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
