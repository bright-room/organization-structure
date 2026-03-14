output "name" {
  description = "Repository name"
  value       = github_repository.this.name
}

output "full_name" {
  description = "Repository full name (org/repo)"
  value       = github_repository.this.full_name
}
