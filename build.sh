#!/usr/bin/env bash

packer build -var-file accessKeys.json packer/consul.json
