module "repository_renovate_config" {
  source = "./modules/repository"

  name        = "renovate-config"
  description = "Shared Renovate configuration presets for bright-room repositories, referenced via `extends`."
  visibility  = "public"
  topics      = ["renovate", "renovate-config", "renovate-preset", "dependency-management", "automation"]

}
