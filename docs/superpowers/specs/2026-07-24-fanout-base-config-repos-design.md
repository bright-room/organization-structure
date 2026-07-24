# fanout base 配布: renovate-config / canonical-files

日付: 2026-07-24
ステータス: 承認済み

## 目的

fanout 配布対象を段階的に拡大する一環として、fanout 基盤側リポジトリである
`renovate-config` と `canonical-files` に base プロファイルのみを配布する。

## 背景

- 現在の fanout 宣言済みリポ: `repository-fanout`, `mindstock`, `repo-policies`
- `repo-policies` は `fanout = {}`(base のみ配布)の先行事例
- base プロファイルの配布物: `.gitignore`(managed-block マージ)、
  `.github/CODEOWNERS`、`renovate.json`(extends エントリのみ構造マージ)、
  `.github/release.yaml`、`.github/workflows/security.yml`、
  `.pre-commit-config.yaml`

## 変更内容(1 PR)

1. `terraform/repository_renovate-config.tf` — モジュールに fanout 宣言を追加:
   `fanout = { contents = { codeowner = "bright-room/br-owners" } }`
2. `terraform/repository_canonical-files.tf` — 同上
3. `terraform/_fanout_manifest.tf` — `local.fanout_modules` に2エントリ追加:
   - `"renovate-config" = module.repository_renovate_config`
   - `"canonical-files" = module.repository_canonical_files`

## 衝突確認(調査済み)

- canonical-files の `renovate.json` は customManagers を多数持つが、worker は
  `structuredDocument`(extends エントリのみ管理)でマージするため保持される。
- CODEOWNERS はリポ個別指定 `codeowner = "bright-room/br-owners"` で配布し、
  アカウント既定(`br-maintainers`)を上書きする(基盤側リポのレビュワーは owner)。
- renovate-config の `.gitignore`(`.tmp/` のみ)は managed-block マージで共存。
- `exclude` 指定は不要。

## 検証

- `terraform fmt -check` / `terraform validate` が通ること
- マージ後: on-merge workflow が apply → fanout-sync を実行し、worker が両リポへ配布
- 配布失敗時は `fanout-rekick` workflow(repos 指定)で再実行

## スコープ外

- `garage-admin-console` / `bright-room` / `br-cluster` への fanout 宣言(次フェーズ)
- worker 側の挙動変更
