module "repository_aktive_storage_example" {
  source = "./modules/repository"

  name        = "aktive-storage-example"
  description = "Example applications demonstrating how to use aktive-storage."
  visibility  = "public"
  topics      = ["kotlin", "jvm", "example", "sample", "file-attachment", "aktive-storage"]

  default_branch_protection = {
    required_status_checks = []
  }
}
