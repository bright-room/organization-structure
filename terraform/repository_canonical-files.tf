module "repository_canonical_files" {
  source = "./modules/repository"

  name        = "canonical-files"
  description = "Canonical common files distributed to repositories by repository-fanout"
  visibility  = "public"
  topics      = ["repository-fanout", "templates", "renovate-config"]

  default_branch_protection = {
    required_status_checks = [
      { context = "validate" },
    ]
  }
}
