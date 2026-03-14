resource "github_membership" "this" {
  username = var.username
  role     = var.role
}

resource "github_organization_role_user" "this" {
  for_each = var.organization_role_ids

  role_id = each.value
  login   = var.username
}
