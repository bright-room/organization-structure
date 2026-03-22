# organization-structure

[English version](README.md)

**bright-room** GitHub組織のリポジトリを管理するためのTerraform設定です。

## 概要

このリポジトリは、Terraformを使用してbright-room GitHub組織内のパブリックリポジトリのライフサイクルを管理します。リポジトリの作成、Issueラベルの設定、ブランチ保護ルールセット、チームアクセス権限、Organization Secretの割り当てを扱います。

組織レベルのリソース（メンバー、チーム、シークレット、メタリポジトリ）については、[organization-structure-administrator](https://github.com/bright-room/organization-structure-administrator) を参照してください。

## 管理対象リソース

| リソース種別 | 説明 |
|---|---|
| リポジトリ | 設定、説明、トピック付きのパブリックリポジトリ |
| Issueラベル | 標準化されたラベルセット（Priority、Type、Close） |
| ブランチ保護 | 承認レビュー必須のデフォルトブランチルールセット |
| タグ保護 | タグの作成/更新/削除に対するカスタムルールセット |
| チームアクセス | リポジトリレベルのチーム権限（push、maintain、admin） |
| Organization Secret | リポジトリごとの組織レベルシークレットへのアクセス付与 |

## ディレクトリ構成

```
organization-structure/
├── .github/workflows/
│   ├── on-pull-request.yml   # PR時のフォーマットチェック、バリデーション、プラン
│   └── on-merge.yml          # mainマージ時の自動適用
├── terraform/
│   ├── _terraform.tf         # プロバイダーとバックエンドの設定
│   ├── _data.tf              # データソース（チーム参照）
│   ├── _locals.tf            # Organization Secretマップ
│   ├── repository_*.tf       # 管理対象リポジトリごとに1ファイル
│   └── modules/
│       └── repository/       # 再利用可能なリポジトリモジュール
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           ├── data.tf
│           ├── locals.tf
│           └── terraform.tf
└── README.md
```

## リポジトリの追加手順

1. `terraform/repository_<name>.tf` ファイルを新規作成します（リポジトリ名はハイフン、ファイル名はアンダースコアを使用）：

    ```hcl
    module "repository_example" {
      source = "./modules/repository"

      name        = "example-repo"
      description = "リポジトリの説明"
      topics      = ["topic1", "topic2"]

      organization_secret_names = [
        # 必要に応じてOrganization Secret名を追加
        # 例: "CHLOE_CHAN_APP_PRIVATE_KEY", "PGP_SIGNING_KEY"
      ]
    }
    ```

2. （任意）タグ保護や追加のブランチルールが必要な場合、カスタムルールセットを追加：

    ```hcl
    module "repository_example" {
      source = "./modules/repository"

      # ... 基本設定 ...

      custom_rulesets = [
        {
          name          = "tag-protection"
          target        = "tag"
          tag_pattern   = "*"
          creation      = true
          update        = true
          deletion      = true
          bypass_actors = []  # 空で全員ブロック、または特定のアクターを追加
        }
      ]
    }
    ```

3. プルリクエストを作成します。CIパイプラインが `terraform fmt`、`terraform validate`、`terraform plan` を自動実行します。

4. レビュー・承認後、`main` にマージします。Terraform applyが自動実行されます。

## 前提条件

- [Terraform](https://www.terraform.io/) v1.14.7以上
- [Terraform Cloud](https://app.terraform.io/) の `bright-room/organization-structure` ワークスペースへのアクセス
- chloe-chan-botのGitHub App認証情報（`CHLOE_CHAN_APP_ID` variable、`CHLOE_CHAN_APP_PRIVATE_KEY` secret）
- Terraform Cloud APIトークン（`TF_API_TOKEN`）

## CI/CDパイプライン

| トリガー | ワークフロー | ジョブ |
|---|---|---|
| プルリクエスト | `on-pull-request.yml` | `check-code-style`（fmt）→ `validate` → `plan`（PRコメントにプランを投稿） |
| mainへのマージ | `on-merge.yml` | `apply`（自動適用） |

両ワークフローはTerraform v1.14.7を使用し、`CHLOE_CHAN_APP_PRIVATE_KEY`、`CHLOE_CHAN_APP_ID`、`TF_API_TOKEN` が必要です。
