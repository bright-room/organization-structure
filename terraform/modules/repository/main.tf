resource "github_repository" "this" {
  name            = var.name
  description     = var.description
  homepage_url    = var.homepage_url
  visibility      = var.visibility
  has_issues      = var.has_issues
  has_projects    = var.has_projects
  has_wiki        = var.has_wiki
  has_discussions = var.has_discussions
  is_template     = var.is_template
  archived        = var.archived
  topics          = var.topics

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge

  # Baseline (enforced, not overridable):
  delete_branch_on_merge = true
  archive_on_destroy     = true
  auto_init              = true

  # Secret scanning + push protection are free for public repos on Free orgs.
  # AI detection and non-provider patterns belong to the paid GitHub Secret
  # Protection product (Team/Enterprise + add-on) and are intentionally not
  # configured here.
  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  lifecycle {
    # `pages` is the deprecated inline attribute on github_repository. Pages
    # itself is managed via the separate `github_repository_pages` resource
    # below; we ignore the inline reflection so Terraform never tries to
    # null it out, which the provider would translate into an API call that
    # destroys the live Pages site.
    ignore_changes = [
      auto_init,
      pages,
    ]
  }
}

resource "github_repository_pages" "this" {
  count = var.pages != null ? 1 : 0

  repository     = github_repository.this.name
  build_type     = var.pages.build_type
  cname          = var.pages.cname
  https_enforced = var.pages.https_enforced

  dynamic "source" {
    for_each = var.pages.source != null ? [var.pages.source] : []

    content {
      branch = source.value.branch
      path   = source.value.path
    }
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = github_repository.this.name
}

resource "github_actions_repository_permissions" "this" {
  count = var.actions_permissions != null ? 1 : 0

  repository           = github_repository.this.name
  enabled              = var.actions_permissions.enabled
  allowed_actions      = var.actions_permissions.allowed_actions
  sha_pinning_required = var.actions_permissions.sha_pinning_required

  dynamic "allowed_actions_config" {
    for_each = var.actions_permissions.allowed_actions == "selected" ? [var.actions_permissions] : []

    content {
      github_owned_allowed = allowed_actions_config.value.github_owned_allowed
      verified_allowed     = allowed_actions_config.value.verified_allowed
      patterns_allowed     = allowed_actions_config.value.patterns_allowed
    }
  }
}

resource "github_issue_labels" "this" {
  repository = github_repository.this.name

  label {
    name        = "Close: Duplicate"
    color       = "dcdcdc"
    description = "重複しているもの(他のIssueやpull requestで対応する)"
  }

  label {
    name        = "Close: Invalid"
    color       = "dcdcdc"
    description = "誤り"
  }

  label {
    name        = "Close: WontFix"
    color       = "dcdcdc"
    description = "対応しない"
  }

  label {
    name        = "Priority: Critical"
    color       = "b60205"
    description = "優先度：緊急"
  }

  label {
    name        = "Priority: High"
    color       = "ff4500"
    description = "優先度：高"
  }

  label {
    name        = "Priority: Medium"
    color       = "ffd700"
    description = "優先度：中"
  }

  label {
    name        = "Priority: Low"
    color       = "4169e1"
    description = "優先度：低"
  }

  label {
    name        = "Meta: Release note ignored"
    color       = "859179"
    description = "リリースノートへの記載しない"
  }

  label {
    name        = "Need: Discussion"
    color       = "da70d6"
    description = "議論が必要"
  }

  label {
    name        = "Need: Help Wanted"
    color       = "da70d6"
    description = "他者のヘルプを求む"
  }

  label {
    name        = "Type: Question"
    color       = "da70d6"
    description = "Q＆A"
  }

  label {
    name        = "Impact: Breaking"
    color       = "b60205"
    description = "破壊的変更を含み、後方互換性が失われるような対応"
  }

  label {
    name        = "Kind: Dependencies"
    color       = "ededed"
    description = "依存ライブラリのアップデート"
  }

  label {
    name        = "Kind: Bug Fix"
    color       = "ff0000"
    description = "バグ関連"
  }

  label {
    name        = "Kind: Documentation"
    color       = "40e0d0"
    description = "ドキュメント追加・修正"
  }

  label {
    name        = "Kind: Tests"
    color       = "008000"
    description = "テスト追加・修正"
  }

  label {
    name        = "Kind: Enhancement"
    color       = "89058a"
    description = "機能強化"
  }

  label {
    name        = "Kind: Feature"
    color       = "00bfff"
    description = "新機能"
  }

  label {
    name        = "Kind: Refactoring"
    color       = "fa8072"
    description = "内部的なリファクタリング(APIの破壊的変更を伴わない範囲)"
  }
}

resource "github_repository_ruleset" "default_branch" {
  name        = "protect-default-branch"
  repository  = github_repository.this.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  dynamic "bypass_actors" {
    for_each = local.default_bypass_actors

    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    pull_request {
      dismiss_stale_reviews_on_push   = true
      require_code_owner_review       = true
      required_approving_review_count = 1
    }

    dynamic "required_status_checks" {
      for_each = length(var.default_branch_protection.required_status_checks) > 0 ? [true] : []

      content {
        dynamic "required_check" {
          for_each = var.default_branch_protection.required_status_checks

          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }
  }
}

resource "github_repository_ruleset" "protect_tags" {
  name        = "protect-tags"
  repository  = github_repository.this.name
  target      = "tag"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  dynamic "bypass_actors" {
    for_each = local.protect_tag_bypass_actors

    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    creation = true
    update   = true
    deletion = true
  }
}

resource "github_repository_ruleset" "required_signatures" {
  for_each = toset(["branch", "tag"])

  name        = "require-signed-commits-${each.key}"
  repository  = github_repository.this.name
  target      = each.key
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~ALL"]
      exclude = []
    }
  }

  rules {
    required_signatures = true
  }
}

resource "github_repository_ruleset" "this" {
  for_each = var.rulesets

  name        = each.key
  repository  = github_repository.this.name
  target      = each.value.target
  enforcement = each.value.enforcement

  conditions {
    ref_name {
      include = each.value.conditions.ref_name.include
      exclude = each.value.conditions.ref_name.exclude
    }
  }

  dynamic "bypass_actors" {
    for_each = local.ruleset_bypass_actors

    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    creation            = each.value.rules.creation
    update              = each.value.rules.update
    deletion            = each.value.rules.deletion
    non_fast_forward    = each.value.rules.non_fast_forward
    required_signatures = each.value.rules.required_signatures

    dynamic "pull_request" {
      for_each = each.value.rules.pull_request != null ? [each.value.rules.pull_request] : []

      content {
        dismiss_stale_reviews_on_push   = pull_request.value.dismiss_stale_reviews_on_push
        require_code_owner_review       = pull_request.value.require_code_owner_review
        required_approving_review_count = pull_request.value.required_approving_review_count
      }
    }

    dynamic "required_status_checks" {
      for_each = length(each.value.rules.required_status_checks) > 0 ? [true] : []

      content {
        dynamic "required_check" {
          for_each = each.value.rules.required_status_checks

          content {
            context        = required_check.value.context
            integration_id = required_check.value.integration_id
          }
        }
      }
    }
  }
}

resource "github_actions_organization_secret_repository" "this" {
  for_each = var.organization_secrets

  secret_name   = each.value
  repository_id = github_repository.this.repo_id
}

resource "github_actions_organization_variable_repository" "this" {
  for_each = var.organization_variables

  variable_name = each.value
  repository_id = github_repository.this.repo_id
}

resource "github_team_repository" "this" {
  for_each = local.teams

  team_id    = each.key
  repository = github_repository.this.name
  permission = each.value.permission
}
