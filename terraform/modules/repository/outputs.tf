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
  description = "fanout manifest の1リポ分エントリ（languages/bundles/contents/exclude）。fanout 未設定なら null（＝配布対象外）"
  value = var.fanout == null ? null : {
    languages = var.fanout.languages
    bundles   = var.fanout.bundles
    contents = merge(
      contains(var.fanout.bundles, "oss") ? { license_holder = var.license_holder } : {},
      var.fanout.contents,
    )
    exclude = var.fanout.exclude
  }
}
