module "team_br_developers" {
  source = "./modules/team"

  name        = "br-developers"
  description = "Organization developers"
  privacy     = "closed"

  // Don't assign member.
}
