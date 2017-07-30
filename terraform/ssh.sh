#!/usr/bin/env bash


ssh admin@$(terraform output ip|cut -d',' -f$1)