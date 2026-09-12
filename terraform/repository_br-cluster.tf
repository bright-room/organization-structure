
module "repository_br_cluster" {
  source = "./modules/repository"

  name        = "br-cluster"
  description = ""
  visibility  = "public"
  topics      = []


  rulesets = {
    "protect-ha-cluster-archive" = {
      target = "branch"
      conditions = {
        ref_name = {
          include = ["refs/heads/ha-cluster-archive"]
        }
      }
      rules = {
        deletion         = true
        non_fast_forward = true
        pull_request = {
          dismiss_stale_reviews_on_push   = true
          require_code_owner_review       = true
          required_approving_review_count = 1
        }
      }
    }
  }

  organization_secrets = [
    local.organization_secrets.chloe_chan_app_private_key,
  ]

  organization_variables = [
    local.organization_variables.chloe_chan_app_id,
  ]

  default_branch_protection = {
    required_status_checks = [
      { context = "action-lint" },
      { context = "ansible-lint" },
      { context = "kustomize-build + kubeconform" },
      { context = "flux-local-test" },
      { context = "policy-test" },
      { context = "packer-fmt" },
      { context = "Lint" },
      { context = "Test" },
      { context = "yaml-lint" },
      { context = "hidden-unicode" },
      { context = "secrets" },
      { context = "sca" },
      { context = "workflow-audit" },
    ]
  }
}
