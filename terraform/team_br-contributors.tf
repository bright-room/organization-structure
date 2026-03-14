module "team_br_contributors" {
  source = "./modules/team"

  name           = "br-contributors"
  description    = "Organization Developers who also serve as repository contributors"
  privacy        = "closed"
  parent_team_id = module.team_br_developers.id

  organization_role_ids = [
    local.organization_roles.all_repo_write,
  ]
}
