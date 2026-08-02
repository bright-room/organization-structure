module "repository_repo_policies" {
  source = "./modules/repository"

  name        = "repo-policies"
  description = "Conftest (OPA/Rego) policies enforcing security prerequisites across repositories"
  visibility  = "public"
  topics      = ["conftest", "opa", "rego", "policy-as-code", "security"]

  default_branch_protection = {
    required_status_checks = concat(
      [{ context = "verify" }],
      local.security_status_checks,
    )
  }
}
