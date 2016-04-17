.ONESHELL:
.SHELLFLAGS = -e
.DEFAULT_GOAL := help
.PHONEY: all

SHELL = /bin/bash
TERRAFORM_VERSION  = $(shell terraform --version | sed -n 1p | grep -oE '[[:digit:]]+.[[:digit:]]+.[[:digit:]]+' || true)
TERRAFORM_COMMANDS = plan apply destroy output refresh show get
CURRENT_HOST_PORT  = $(shell sed '/^\#/d' terraform.tfvars | grep 'containers_host_port' | tail -n 1 | cut -d "=" -f2- | sed 's/^[[:space:]]*//')

# allows terraform args to be appended and not treated as `make` targets
# example: "make -- <command> <args>"
ifneq ($(findstring $(firstword $(MAKECMDGOALS)),$(TERRAFORM_COMMANDS)),)
TF_COMMAND = $(wordlist 1,1,$(MAKECMDGOALS))
TF_ARGS 	 = $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(TF_ARGS):;@:)
endif

all: _remote_tf _validate_tf _run_tf deploy $(TERRAFORM_COMMANDS)

help: ## Prints this help message
	@echo "usage: make <command> [<args>]"
	@echo
	@echo "Available commands are:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-4s\033[36m%-11s\033[0m %s\n", "", $$1, $$2}'
	@echo

_validate_tf:
ifeq ($(TERRAFORM_VERSION),)
	@echo "Unable to locate terraform."
	@echo "Install terraform to continue."
	@exit 1
endif

_remote_tf: _validate_tf
	@echo "Configuring remote state..."
	terraform remote config -backend=s3 -backend-config="bucket=tripler-tf-state" -backend-config="key=terraform.tfstate"

_run_tf: _remote_tf
	@echo "Executing: terraform $(TF_COMMAND) $(TF_ARGS)"
	@terraform $(TF_COMMAND) $(TF_ARGS)

apply: plan ## Builds or changes infrastructure
	@terraform apply tf.plan $(TF_ARGS) && rm tf.plan

destroy: _remote_tf ## Destroy Terraform-managed infrastructure
	terraform destroy -target module.containers -force && \
		terraform destroy -force

get: _run_tf ## Download and install modules for the configuration

output: _run_tf ## Read an output from a state file

plan: _remote_tf ## Generate and show an execution plan
	terraform plan -out tf.plan $(TF_ARGS)

refresh: _run_tf ## Update local state file against real resources

show: _run_tf ## Inspect Terraform state or plan

deploy: _remote_tf ## Deploy containers onto Swarm cluster
	@NEW_CONTAINER_PORT=$$(python -c 'import random; print random.randint(1024,65535)'); \
		echo "new container port: $$NEW_CONTAINER_PORT"; \
		terraform plan -target module.containers -var "containers_host_port=$$NEW_CONTAINER_PORT" -out tf.plan && \
		terraform apply tf.plan && rm tf.plan \
