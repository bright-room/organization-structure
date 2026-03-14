module "member_br_github_manager" {
  source = "./modules/member"

  username = "br-github-manager"
  role     = "admin"

  # organization_role_ids = [
  #   local.organization_roles.all_repo_admin,
  # ]
}
