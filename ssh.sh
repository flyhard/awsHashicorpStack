#!/usr/bin/env bash


ssh admin@$(terraform output -state=terraform/terraform.tfstate ip|cut -d',' -f$1) -L8500:localhost:8500