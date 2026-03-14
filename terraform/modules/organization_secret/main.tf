resource "github_actions_organization_secret" "this" {
  secret_name     = var.secret_name
  visibility      = "selected"
  plaintext_value = "imported-via-terraform"

  lifecycle {
    ignore_changes = [plaintext_value, encrypted_value]
  }
}
