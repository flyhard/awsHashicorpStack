PACKER=packer
TERRAFORM=terraform
.PHONY: all
all: consul deploy-consul

.PHONY: consul
consul: consul.log

consul.log: packer/consul.json consul.yml $(shell find roles -type f)
	$(PACKER) build -var-file accessKeys.json packer/consul.json && touch consul.log


.PHONY: deploy-consul
deploy-consul: terraform/terraform.log

terraform/terraform.log: terraform/*.tf terraform/*.tfvars consul.log
	cd terraform ; $(TERRAFORM) apply && touch terraform.log
	cd terraform; terraform refresh

.PHONY: demo
demo:
	./nomad-jobs/run_local_demo.sh

.PHONY: clean
clean:
	cd terraform ; $(TERRAFORM) destroy -force