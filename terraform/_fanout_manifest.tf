# fanout 配布対象（languages/bundles を持つ repo）を集約して manifest を output する。
# revision / sourceCommit は on-merge CI（.github/scripts/fanout-sync.sh）が付与する。
# 注：配布対象 repo を増やしたら fanout_modules に1行追加する（spec §3 実装メモ）。
locals {
  fanout_modules = {
    "repository-fanout" = module.repository_repository_fanout
    "endpoint-gate"     = module.repository_endpoint_gate
    "idem"              = module.repository_idem
    "mindstock"         = module.repository_mindstock
    "repo-policies"     = module.repository_repo_policies
  }

  # アカウント既定の codeowner(spec §3: Org → bright-room/br-maintainers)。
  # repo 側の fanout_contents.codeowner 指定が常に優先される。
  fanout_default_contents = {
    codeowner = "bright-room/br-maintainers"
  }

  fanout_repositories = {
    for name, mod in local.fanout_modules :
    name => merge(mod.fanout_entry, {
      contents = merge(local.fanout_default_contents, mod.fanout_entry.contents)
    })
    if mod.fanout_entry != null
  }
}

output "fanout_manifest" {
  description = "fanout worker へ送る manifest（account + repositories）。revision/sourceCommit は CI が付与。"
  value = {
    account      = "bright-room"
    repositories = local.fanout_repositories
  }
}
