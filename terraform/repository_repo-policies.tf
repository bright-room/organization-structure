module "repository_repo_policies" {
  source = "./modules/repository"

  name        = "repo-policies"
  description = "Conftest (OPA/Rego) policies enforcing security prerequisites across repositories"
  visibility  = "public"
  topics      = ["conftest", "opa", "rego", "policy-as-code", "security"]

  # policy は各リポの security.yml から main 参照で即時反映されるため、
  # main への変更は CI(conftest verify)green を必須にする
  default_branch_protection = {
    required_status_checks = [
      { context = "verify" },
    ]
  }

  fanout = {}
}
