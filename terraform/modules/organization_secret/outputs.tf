output "secret_name" {
  description = "Name of the organization secret"
  value       = github_actions_organization_secret.this.secret_name
}
