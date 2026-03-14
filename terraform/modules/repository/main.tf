resource "github_repository" "this" {
  name                   = var.name
  description            = var.description
  homepage_url           = var.homepage_url
  visibility             = var.visibility
  has_issues             = var.has_issues
  has_projects           = var.has_projects
  has_wiki               = var.has_wiki
  has_discussions        = var.has_discussions
  allow_merge_commit     = var.allow_merge_commit
  allow_squash_merge     = var.allow_squash_merge
  allow_rebase_merge     = var.allow_rebase_merge
  delete_branch_on_merge = var.delete_branch_on_merge
  auto_init              = var.auto_init
  is_template            = var.is_template
  archived               = var.archived
  archive_on_destroy     = var.archive_on_destroy
  vulnerability_alerts   = var.vulnerability_alerts
  topics                 = var.topics

  lifecycle {
    ignore_changes = [
      auto_init,
    ]
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
    name        = "dependencies"
    color       = "ededed"
    description = "依存ライブラリに関するラベル"
  }

  label {
    name        = "Priority: High"
    color       = "ff4500"
    description = "優先度：高"
  }

  label {
    name        = "Priority: Low"
    color       = "4169e1"
    description = "優先度：低"
  }

  label {
    name        = "Priority: Medium"
    color       = "ffd700"
    description = "優先度：中"
  }

  label {
    name        = "Release note ignored"
    color       = "859179"
    description = "リリースノートへの記載しない"
  }

  label {
    name        = "renovate"
    color       = "ededed"
    description = ""
  }

  label {
    name        = "Type: Bug"
    color       = "ff0000"
    description = "バグ関連"
  }

  label {
    name        = "Type: Discussion"
    color       = "14D658"
    description = "議論にが必要"
  }

  label {
    name        = "Type: Document"
    color       = "40e0d0"
    description = "ドキュメント"
  }

  label {
    name        = "Type: Enhancement"
    color       = "89058a"
    description = "機能強化"
  }

  label {
    name        = "Type: Feature"
    color       = "00bfff"
    description = "新機能"
  }

  label {
    name        = "Type: Help Wanted"
    color       = "da70d6"
    description = "他者のヘルプを求む"
  }

  label {
    name        = "Type: Publishing"
    color       = "00ff00"
    description = "公開に伴う作業"
  }

  label {
    name        = "Type: Question"
    color       = "F8950F"
    description = "Q＆A"
  }

  label {
    name        = "Type: Refactoring"
    color       = "fa8072"
    description = "リファクタリング"
  }

  label {
    name        = "Type: Specification Change"
    color       = "fc707d"
    description = "仕様変更"
  }

  label {
    name        = "Type: Test"
    color       = "008000"
    description = "テスト"
  }
}

resource "github_repository_ruleset" "default_branch" {
  count = var.default_branch_protection.enabled ? 1 : 0

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
    for_each = var.default_branch_protection.bypass_actors

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
      dismiss_stale_reviews_on_push   = false
      require_code_owner_review       = false
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
    for_each = each.value.bypass_actors

    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }

  rules {
    creation         = each.value.rules.creation
    update           = each.value.rules.update
    deletion         = each.value.rules.deletion
    non_fast_forward = each.value.rules.non_fast_forward

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

resource "github_team_repository" "this" {
  for_each = var.teams

  team_id    = each.key
  repository = github_repository.this.name
  permission = each.value.permission
}
