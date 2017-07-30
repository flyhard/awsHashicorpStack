PACKER=packer
TERRAFORM=terraform
.PHONY: all
all: consul deploy-consul

.PHONY: consul
consul: consul.log

consul.log: packer/consul.json consul.yml
	$(PACKER) build -var-file accessKeys.json packer/consul.json | tee packer/consul.log


.PHONY: deploy-consul
deploy-consul: terraform/terraform.tfstate

terraform/terraform.tfstate: terraform/*.tf terraform/*.tfvars packer/consul.log
	cd terraform ; $(TERRAFORM) apply | tee terraform.log