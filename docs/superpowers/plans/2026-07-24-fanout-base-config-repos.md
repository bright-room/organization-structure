# fanout base 配布(renovate-config / canonical-files)実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `renovate-config` と `canonical-files` を fanout の base のみ配布対象として宣言する。

**Architecture:** 各 repository モジュールに `fanout = {}`(profiles 空 = base のみ配布)を追加し、`terraform/_fanout_manifest.tf` の `local.fanout_modules` にエントリを追加して `fanout_manifest` output に載せる。配布自体はマージ後に on-merge workflow → fanout worker が行う。

**Tech Stack:** Terraform 1.15.2 / terraform-provider-github

## Global Constraints

- 変更は spec(`docs/superpowers/specs/2026-07-24-fanout-base-config-repos-design.md`)記載の3ファイルのみ。他ファイルに触れない。
- `fanout = {}` の書式は `terraform/repository_repo-policies.tf:17` の先行事例に合わせる。
- `exclude` / `contents` は指定しない(spec の衝突確認で不要と判断済み)。
- 検証は `terraform fmt -check -recursive terraform` と `terraform -chdir=terraform validate`(state 不要。init 未実施なら `terraform -chdir=terraform init -backend=false` を先に実行)。

---

### Task 1: renovate-config を fanout 宣言

**Files:**
- Modify: `terraform/repository_renovate-config.tf`(モジュール末尾)
- Modify: `terraform/_fanout_manifest.tf:5-9`(`fanout_modules` マップ)

**Interfaces:**
- Consumes: `module.repository_renovate_config`(既存)、`modules/repository` の `fanout` 変数(`terraform/modules/repository/variables.tf:193`、全属性 optional なので `{}` が有効)
- Produces: `local.fanout_modules["renovate-config"]` エントリ。`fanout_manifest` output に `repositories["renovate-config"]` が現れる

- [ ] **Step 1: repository_renovate-config.tf に fanout ブロックを追加**

`default_branch_protection` ブロックの後、モジュールの閉じ括弧の前に追加:

```hcl
  fanout = {}
```

変更後のファイル全体:

```hcl
module "repository_renovate_config" {
  source = "./modules/repository"

  name        = "renovate-config"
  description = "Shared Renovate configuration presets for bright-room repositories, referenced via `extends`."
  visibility  = "public"
  topics      = ["renovate", "renovate-config", "renovate-preset", "dependency-management", "automation"]

  default_branch_protection = {
    required_status_checks = []
  }

  fanout = {}
}
```

- [ ] **Step 2: _fanout_manifest.tf の fanout_modules にエントリを追加**

```hcl
  fanout_modules = {
    "repository-fanout" = module.repository_repository_fanout
    "mindstock"         = module.repository_mindstock
    "repo-policies"     = module.repository_repo_policies
    "renovate-config"   = module.repository_renovate_config
  }
```

- [ ] **Step 3: fmt / validate で検証**

Run: `terraform fmt -check -recursive terraform && terraform -chdir=terraform validate`
Expected: fmt は出力なし(差分なし)、validate は `Success! The configuration is valid.`
(validate が provider 未初期化エラーの場合は先に `terraform -chdir=terraform init -backend=false` を実行して再試行)

- [ ] **Step 4: Commit**

```bash
git add terraform/repository_renovate-config.tf terraform/_fanout_manifest.tf
git commit -m "feat(fanout): renovate-config を base のみ配布対象に宣言"
```

---

### Task 2: canonical-files を fanout 宣言

**Files:**
- Modify: `terraform/repository_canonical-files.tf`(モジュール末尾)
- Modify: `terraform/_fanout_manifest.tf`(`fanout_modules` マップ、Task 1 適用後の状態)

**Interfaces:**
- Consumes: `module.repository_canonical_files`(既存)、Task 1 適用後の `fanout_modules` マップ
- Produces: `local.fanout_modules["canonical-files"]` エントリ。`fanout_manifest` output に `repositories["canonical-files"]` が現れる

- [ ] **Step 1: repository_canonical-files.tf に fanout ブロックを追加**

変更後のファイル全体:

```hcl
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

  fanout = {}
}
```

- [ ] **Step 2: _fanout_manifest.tf の fanout_modules にエントリを追加**

```hcl
  fanout_modules = {
    "repository-fanout" = module.repository_repository_fanout
    "mindstock"         = module.repository_mindstock
    "repo-policies"     = module.repository_repo_policies
    "renovate-config"   = module.repository_renovate_config
    "canonical-files"   = module.repository_canonical_files
  }
```

- [ ] **Step 3: fmt / validate で検証**

Run: `terraform fmt -check -recursive terraform && terraform -chdir=terraform validate`
Expected: fmt は出力なし、validate は `Success! The configuration is valid.`

- [ ] **Step 4: Commit**

```bash
git add terraform/repository_canonical-files.tf terraform/_fanout_manifest.tf
git commit -m "feat(fanout): canonical-files を base のみ配布対象に宣言"
```

---

### Task 3: PR 作成

**Files:** なし(git 操作のみ)

**Interfaces:**
- Consumes: Task 1 / Task 2 のコミット(ブランチ `feat/fanout-base-config-repos`)
- Produces: main への PR

- [ ] **Step 1: push して PR を作成**

```bash
git push -u origin feat/fanout-base-config-repos
gh pr create --title "feat(fanout): renovate-config / canonical-files を base のみ配布対象に宣言" --body "$(cat <<'EOF'
## 概要

fanout 配布対象の段階拡大として、fanout 基盤側リポジトリ 2 つに `fanout = {}`(base のみ配布)を宣言する。

- `renovate-config`: `fanout = {}` を追加、manifest に登録
- `canonical-files`: `fanout = {}` を追加、manifest に登録

設計: `docs/superpowers/specs/2026-07-24-fanout-base-config-repos-design.md`

## 衝突確認

- canonical-files の customManagers 入り `renovate.json` は worker の構造マージ(extends のみ管理)で保持される
- 既存 `.github/CODEOWNERS` はアカウント既定値と一致
- `exclude` 不要

## マージ後の動き

on-merge workflow が terraform apply → fanout-sync を実行し、worker が両リポへ base を配布する。失敗時は fanout-rekick で再実行可能。

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Expected: PR URL が出力される

- [ ] **Step 2: マージ後の配布確認手順を報告**

PR マージ後(ユーザー操作)に確認すること:
- on-merge workflow の成功: `gh run list --workflow=on-merge.yml --limit 1`
- 両リポに fanout の配布 PR/commit が作られていること(例: `gh api repos/bright-room/renovate-config/commits --jq '.[0].commit.message'`)
