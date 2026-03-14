module "member_kukv" {
  source = "./modules/member"

  username = "kukv"
  role     = "admin"

  # organization_role_ids = [
  #   local.organization_roles.all_repo_admin,
  # ]
}
