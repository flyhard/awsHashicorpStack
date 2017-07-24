#!/bin/bash

#set -e

sudo systemctl stop vault.service
sudo systemctl stop consul.service && \
sudo rm -rf /usr/local/bin/consul && \
sudo rm -rf /usr/local/consul && \
sudo rm -rf /var/lib/consul && \
sudo rm -rf /etc/consul &&
exit 0
exit 1

