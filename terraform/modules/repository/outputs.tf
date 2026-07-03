output "name" {
  description = "Repository name"
  value       = github_repository.this.name
}

output "full_name" {
  description = "Repository full name (org/repo)"
  value       = github_repository.this.full_name
}

output "repo_id" {
  description = "Repository ID"
  value       = github_repository.this.repo_id
}

output "fanout_entry" {
  description = "fanout manifest の1リポ分エントリ（languages/bundles/vars）"
  value = {
    languages = var.languages
    bundles   = var.bundles
    vars      = var.fanout_vars
  }
}
