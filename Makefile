TF_DIR := terraform

.PHONY: init lock plan apply destroy fmt validate

init:
	terraform -chdir=$(TF_DIR) init

lock:
	terraform -chdir=$(TF_DIR) providers lock \
		-platform=linux_amd64 \
		-platform=darwin_arm64 \
		-platform=darwin_amd64

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
