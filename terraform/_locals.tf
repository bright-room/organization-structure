locals {
  # Custom organization role IDs
  # https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/managing-custom-organization-roles
  organization_roles = {
    all_repo_admin    = 8136
    all_repo_maintain = 8135
    all_repo_read     = 8132
    all_repo_triage   = 8133
    all_repo_write    = 8134
    app_manager       = 33679
    ci_cd_admin       = 26237
    security_manager  = 138
  }

  # GitHub App IDs for ruleset bypass_actors
  github_app_ids = {
    renovate_bot = 2740
  }
}
