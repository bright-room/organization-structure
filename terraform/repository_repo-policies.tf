module "repository_repo_policies" {
  source = "./modules/repository"

  name        = "repo-policies"
  description = "Conftest (OPA/Rego) policies enforcing security prerequisites across repositories"
  visibility  = "public"
  topics      = ["conftest", "opa", "rego", "policy-as-code", "security"]

  fanout = {}
}
