module "team_br_maintainers" {
  source = "./modules/team"

  name           = "br-maintainers"
  description    = "Organization developers who also serve as repository maintainers."
  privacy        = "closed"
  parent_team_id = module.team_br_developers.id

  organization_role_ids = [
    local.organization_roles.all_repo_maintain,
  ]
}
