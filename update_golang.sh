#!/bin/bash

sudo apt update && sudo apt upgrade -y

read -p "Please enter the Go version you wish to install: " GO_VER
wget -c "https://go.dev/dl/go$GO_VER.linux-amd64.tar.gz" -P /tmp
sudo rm -r /usr/local/go
sudo tar -C /usr/local -xzf /tmp/go$GO_VER.linux-amd64.tar.gz
sudo rm /tmp/go$GO_VER.linux-amd64.tar.gz
go version
