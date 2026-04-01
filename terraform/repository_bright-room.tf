
module "repository_bright_room" {
  source = "./modules/repository"

  name        = "bright-room"
  description = "Homepage for the bright-room organization."
  visibility  = "public"

  default_branch_protection = {
    required_status_checks = []
  }
}
