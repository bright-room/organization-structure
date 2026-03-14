TF_DIR := terraform

.PHONY: init plan apply destroy fmt validate

init:
	terraform -chdir=$(TF_DIR) init

plan:
	terraform -chdir=$(TF_DIR) plan

apply:
	terraform -chdir=$(TF_DIR) apply

destroy:
	terraform -chdir=$(TF_DIR) destroy

fmt:
	terraform fmt -recursive $(TF_DIR)

validate:
	terraform -chdir=$(TF_DIR) validate
