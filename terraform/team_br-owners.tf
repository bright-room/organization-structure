module "team_br_owners" {
  source = "./modules/team"

  name        = "br-owners"
  description = "Organization owners"
  privacy     = "closed"

  organization_role_ids = [
    local.organization_roles.all_repo_admin,
  ]

  members = {
    (module.member_kukv.username)              = { role = "maintainer" }
    (module.member_br_github_manager.username) = { role = "maintainer" }
  }
}
